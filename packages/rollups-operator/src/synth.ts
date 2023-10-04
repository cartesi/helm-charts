import {
    V1ConfigMap,
    V1Container,
    V1Deployment,
    V1EnvVar,
    V1Ingress,
    V1ObjectMeta,
    V1PodTemplateSpec,
    V1Service,
    V1Volume,
} from "@kubernetes/client-node";

import { ApplicationCustomResource } from "./application.js";
import {
    database,
    deployment,
    emptyVolume,
    env,
    file,
    grpcProbe,
    httpProbe,
    mount,
    service,
    volume,
} from "./util.js";

export type Resources = {
    configMaps: V1ConfigMap[];
    deployments: V1Deployment[];
    services: V1Service[];
    ingresses: V1Ingress[];
};

export default class Synthetizer {
    protected commonLabels: V1ObjectMeta["labels"];
    protected v = "1.0.0";

    constructor() {
        // define common labels for all resources
        this.commonLabels = {
            "app.kubernetes.io/name": "cartesi-rollups-node",
            "app.kubernetes.io/version": this.v,
            "app.kubernetes.io/managed-by": "cartesi-rollups-operator",
        };
    }

    public synth(cr: ApplicationCustomResource): Resources {
        const { address, blockHash, blockNumber, cid, transactionHash } =
            cr.spec;
        const name = cr.metadata!.name!;
        const namespace = cr.metadata?.namespace!;
        const resources = {};
        const securityContext = {};
        const logLevel = "info";
        const serviceAccountName = "default";

        // expected configuration
        const config = "cartesi-rollups-config";
        const databaseSecret = "cartesi-rollups-database";
        const mnemonicSecret = "cartesi-rollups-mnemonic";

        // define the docker images used
        const reg = "docker.io";
        const { v } = this;
        const images = {
            advanceRunner: `${reg}/cartesi/rollups-advance-runner:${v}`,
            dispatcher: `${reg}/cartesi/rollups-dispatcher:${v}`,
            graphqlServer: `${reg}/cartesi/rollups-graphql-server:${v}`,
            indexer: `${reg}/cartesi/rollups-indexer:${v}`,
            inspectServer: `${reg}/cartesi/rollups-inspect-server:${v}`,
            machineDownload: `sunodo/cartesi-machine-download:devel`,
            serverManager: `docker.io/cartesi/server-manager:0.7.0`,
            stateServer: `${reg}/cartesi/rollups-state-server:${v}`,
        };

        const log = { name: "RUST_LOG", value: logLevel };
        const labels = {
            ...this.commonLabels,
            "app.kubernetes.io/instance": name,
            "dapp.rollups.cartesi.io/address": address,
        };

        // ports used by containers
        const ports = {
            graphqlServer: 4000,
            inspectServer: 5005,
            serverManager: 5001,
            stateServer: 50051,
        };
        const healthcheckPorts = {
            dispatcher: 8080,
            graphqlServer: 8081,
            indexer: 8082,
            inspectServer: 8083,
        };

        // config with application information
        const dapp = file(name, labels, "/deployments", "dapp.json", {
            address,
            blockHash,
            blockNumber,
            transactionHash,
        });

        const chainId = env("CHAIN_ID").fromKey("chain_id").of(config);
        const redis = env("REDIS_ENDPOINT").fromKey("redis").of(config);
        const epochDuration = env("RD_EPOCH_DURATION")
            .fromKey("epoch_duration")
            .of(config);
        const confirmations = env("TX_DEFAULT_CONFIRMATIONS")
            .fromKey("confirmations")
            .of(config);

        // server-manager and advance-runner deployment
        const snapshot = emptyVolume("shared-machine-snapshots").mountedAt(
            "/var/opt/cartesi/machine-snapshots"
        );
        const advanceRunner: V1Container = {
            name: "advance-runner",
            image: images.advanceRunner,
            resources,
            args: [
                `--dapp-contract-address`,
                address,
                "--snapshot-dir",
                snapshot.mount.mountPath,
                "--snapshot-latest",
                `${snapshot.mount.mountPath}/latest`,
            ],
            env: [log, redis, chainId],
            volumeMounts: [snapshot.mount],
        };

        const serverManager: V1Container = {
            name: "server-manager",
            image: images.serverManager,
            resources,
            livenessProbe: grpcProbe(ports.serverManager),
            args: [
                "server-manager",
                `--manager-address=0.0.0.0:${ports.serverManager}`,
            ],
            ports: [{ containerPort: ports.serverManager }],
            env: [
                { name: "SERVER_MANAGER_LOG_LEVEL", value: logLevel },
                { name: "REMOTE_CARTESI_MACHINE_LOG_LEVEL", value: logLevel },
            ],
            volumeMounts: [snapshot.mount],
        };

        // init container to download cartesi machine snapshot from IPFS
        const downloadMachine: V1Container = {
            name: "download-machine",
            image: images.machineDownload,
            args: [
                "ipget",
                cid,
                "--output",
                `${snapshot.mount.mountPath}/0_0`,
                "--progress",
            ],
            volumeMounts: [snapshot.mount],
        };

        // init container to create a symlink expected by the advance-runner
        const createLink: V1Container = {
            name: "create-link",
            image: "busybox",
            args: [
                "ln",
                "-s",
                `${snapshot.mount.mountPath}/0_0`,
                `${snapshot.mount.mountPath}/latest`,
            ],
            volumeMounts: [snapshot.mount],
        };

        const machinePod: V1PodTemplateSpec = {
            metadata: {
                labels: {
                    ...labels,
                    "app.kubernetes.io/component": "server-manager",
                },
            },
            spec: {
                serviceAccountName,
                securityContext,
                initContainers: [downloadMachine, createLink],
                containers: [advanceRunner, serverManager],
                volumes: [snapshot.volume],
            },
        };

        // database helper for setting up access using secret values
        // return a volume, mount and env vars, to be used by containers and pods
        const db = database("database", databaseSecret);

        // ethereum gateway configuration
        const eth = (prefix: string): V1EnvVar[] => [
            env(`${prefix}HTTP_ENDPOINT`).fromKey("rpc_url").of(config),
            env(`${prefix}WS_ENDPOINT`).fromKey("rpc_ws_url").of(config),
        ];

        // database setup
        const databaseName = address;
        const databaseCreator: V1Container = {
            name: "database-creator",
            image: "postgres:13.3-alpine",
            command: ["sh", "-c", `createdb "${databaseName}" || true`],
            volumeMounts: [db.mount],
            env: db.env("std"),
        };

        // node deployment
        const mnemonic: V1Volume = {
            name: "mnemonic",
            secret: { secretName: mnemonicSecret },
        };

        // rollups contracts addresses
        const contracts = volume("contracts")
            .fromKey("contracts.json")
            .of(config)
            .mountedAt("/opt/cartesi/share");

        const dispatcher: V1Container = {
            name: "dispatcher",
            image: images.dispatcher,
            resources,
            args: [
                "--sc-grpc-endpoint",
                `http://localhost:${ports.stateServer}`,
                "--rd-rollups-deployment-file",
                contracts.absolutePath,
                "--rd-dapp-deployment-file",
                dapp.absolutePath,
                "--auth-mnemonic-file",
                "/var/run/secrets/mnemonic/MNEMONIC",
                "--sc-default-confirmations",
                "0", // XXX
                "--http-server-port",
                healthcheckPorts.dispatcher.toString(),
            ],
            env: [
                log,
                redis,
                confirmations,
                env("TX_CHAIN_ID").fromKey("chain_id").of(config),
                epochDuration,
                ...eth("TX_PROVIDER_"),
            ],
            livenessProbe: httpProbe(healthcheckPorts.dispatcher),
            volumeMounts: [
                mount(mnemonic).at("/var/run/secrets/mnemonic", {
                    readOnly: true,
                }),
                dapp.mount,
                contracts.mount,
            ],
        };

        const stateServer: V1Container = {
            name: "state-server",
            image: images.stateServer,
            resources,
            args: [
                "--ss-server-address",
                `0.0.0.0:${ports.stateServer}`,
                "--sf-genesis-block",
                blockNumber.toString(), // XXX: is this the right genesis block?
            ],
            livenessProbe: grpcProbe(ports.stateServer),
            env: [log, ...eth("BH_")],
            ports: [{ containerPort: ports.stateServer }],
        };

        const indexer: V1Container = {
            name: "indexer",
            image: images.indexer,
            resources,
            args: [
                "--dapp-contract-address",
                address,
                "--healthcheck-port",
                healthcheckPorts.indexer.toString(),
            ],
            livenessProbe: httpProbe(healthcheckPorts.indexer),
            env: [log, redis, chainId, ...db.env("rollups", databaseName)],
            volumeMounts: [db.mount],
        };

        const node: V1PodTemplateSpec = {
            metadata: {
                labels: { ...labels, "app.kubernetes.io/component": "node" },
            },
            spec: {
                serviceAccountName,
                securityContext,
                containers: [dispatcher, stateServer, indexer],
                volumes: [dapp.volume, contracts.volume, mnemonic, db.volume],
            },
        };

        const inspectServer: V1Container = {
            name: "inspect-server",
            image: images.inspectServer,
            args: [
                "--inspect-server-address",
                `0.0.0.0:${ports.inspectServer}`,
                "--server-manager-address",
                `server-manager:${ports.serverManager}`,
                "--session-id",
                "default_rollups_id",
                "--healthcheck-port",
                healthcheckPorts.inspectServer.toString(),
            ],
            resources,
            livenessProbe: httpProbe(healthcheckPorts.inspectServer),
            env: [log],
            ports: [{ containerPort: ports.inspectServer }],
        };

        const graphqlServer: V1Container = {
            name: "graphql-server",
            image: images.graphqlServer,
            args: [
                "--graphql-host",
                "0.0.0.0",
                "--graphql-port",
                ports.graphqlServer.toString(),
                "--healthcheck-port",
                healthcheckPorts.graphqlServer.toString(),
            ],
            resources,
            livenessProbe: httpProbe(healthcheckPorts.graphqlServer),
            env: [log, ...db.env("rollups", databaseName)],
            ports: [{ containerPort: ports.graphqlServer }],
            volumeMounts: [db.mount],
        };

        const reader: V1PodTemplateSpec = {
            metadata: {
                labels: {
                    ...labels,
                    "app.kubernetes.io/component": "reader",
                },
            },
            spec: {
                serviceAccountName,
                securityContext,
                initContainers: [databaseCreator],
                containers: [inspectServer, graphqlServer],
                volumes: [db.volume],
            },
        };

        const graphqlService = service(
            name,
            "graphql-server",
            ports.graphqlServer,
            labels,
            reader.metadata?.labels
        );

        const inspectService = service(
            name,
            "inspect-server",
            ports.inspectServer,
            labels,
            reader.metadata?.labels
        );

        const serverManagerService = service(
            name,
            "server-manager",
            ports.serverManager,
            labels,
            machinePod.metadata?.labels
        );

        const ingress: V1Ingress = {
            apiVersion: "networking.k8s.io/v1",
            kind: "Ingress",
            metadata: {
                name: `${name}-ingress`,
                labels: {
                    ...labels,
                    "app.kubernetes.io/component": "ingress",
                },
                annotations: {
                    "traefik.ingress.kubernetes.io/router.middlewares": `${namespace}-cartesi-rollups-strip-address@kubernetescrd`,
                },
            },
            spec: {
                rules: [
                    {
                        http: {
                            paths: [
                                {
                                    path: `/${address}/graphql`,
                                    pathType: "Exact",
                                    backend: {
                                        service: {
                                            name: graphqlService.metadata!
                                                .name!,
                                            port: {
                                                number: ports.graphqlServer,
                                            },
                                        },
                                    },
                                },
                                {
                                    path: `/${address}/inspect`,
                                    pathType: "Exact",
                                    backend: {
                                        service: {
                                            name: inspectService.metadata!
                                                .name!,
                                            port: {
                                                number: ports.inspectServer,
                                            },
                                        },
                                    },
                                },
                            ],
                        },
                    },
                ],
            },
        };

        return {
            configMaps: [dapp.configMap],
            ingresses: [ingress],
            deployments: [
                deployment(name, "node", node, labels),
                deployment(name, "reader", reader, labels),
                deployment(name, "server-manager", machinePod, labels),
            ],
            services: [graphqlService, inspectService, serverManagerService],
        };
    }
}
