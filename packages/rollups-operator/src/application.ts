import path from "path";
import k8s, { KubeConfig, KubernetesObject } from "@kubernetes/client-node";

import Operator, { ResourceEvent, ResourceEventType } from "./operator.js";
import Synthetizer, { Resources } from "./synth.js";

export interface ApplicationCustomResource extends KubernetesObject {
    spec: ApplicationCustomResourceSpec;
    status: ApplicationCustomResourceStatus;
}

export interface ApplicationCustomResourceSpec {
    address: string;
    blockHash: string;
    blockNumber: string;
    transactionHash: string;
    cid: string;
}

export interface ApplicationCustomResourceStatus {
    observedGeneration?: number;
}

export default class ApplicationOperator extends Operator {
    protected synthetizer: Synthetizer;
    protected namespace: string;

    constructor(kubeConfig: KubeConfig, namespace: string) {
        super(kubeConfig, console);
        this.namespace = namespace;

        // instantiate resources synthetizer
        this.synthetizer = new Synthetizer();
    }

    protected async init() {
        // register CRD
        const crdFile = path.join(
            path.dirname(new URL(import.meta.url).pathname),
            "dapp.yaml"
        );
        const { group, versions, plural } =
            await this.registerCustomResourceDefinition(crdFile);

        // watch CRD resources
        await this.watchResource(
            group,
            versions[0].name,
            plural,
            async (e) => {
                console.log(e);
                if (
                    e.type === ResourceEventType.Added ||
                    e.type === ResourceEventType.Modified
                ) {
                    if (
                        !(await this.handleResourceFinalizer(
                            e,
                            group,
                            (event) => this.delete(event)
                        ))
                    ) {
                        await this.create(e);
                    }
                } else if (e.type === ResourceEventType.Deleted) {
                    await this.delete(e);
                }
            },
            this.namespace
        );
    }

    protected async print(resources: Resources) {
        const configMaps = resources.configMaps
            .map((r) => JSON.stringify(r, undefined, 4))
            .join("\n---\n");
        const deployments = resources.deployments
            .map((r) => JSON.stringify(r, undefined, 4))
            .join("\n---\n");
        const services = resources.services
            .map((r) => JSON.stringify(r, undefined, 4))
            .join("\n---\n");

        console.log(configMaps);
        console.log("---");
        console.log(deployments);
        console.log("---");
        console.log(services);
    }

    protected async apply(resources: Resources) {
        const core = this.k8sApi;
        const apps = this.kubeConfig.makeApiClient(k8s.AppsV1Api);
        const network = this.kubeConfig.makeApiClient(k8s.NetworkingV1Api);
        const { namespace } = this;

        const ignore409 = (err: any) => {
            if ((err as any).response?.statusCode !== 409) {
                throw err;
            }
        };

        // create all configMaps
        resources.configMaps.forEach((r) => {
            console.log(`creating ${r.kind} ${r.metadata!.name}`);
            core.createNamespacedConfigMap(namespace, r)
                .then(({ body }) => {
                    console.log(`created ${body.kind} ${body.metadata!.name}`);
                })
                .catch(ignore409);
        });

        // create all deployments
        resources.deployments.forEach((r) => {
            console.log(`creating ${r.kind} ${r.metadata!.name}`);
            apps.createNamespacedDeployment(namespace, r)
                .then(({ body }) => {
                    console.log(`created ${body.kind} ${body.metadata!.name}`);
                })
                .catch(ignore409);
        });

        // create all services
        resources.services.forEach((r) => {
            console.log(`creating ${r.kind} ${r.metadata!.name}`);
            core.createNamespacedService(namespace, r)
                .then(({ body }) => {
                    console.log(`created ${body.kind} ${body.metadata!.name}`);
                })
                .catch(ignore409);
        });

        // create all ingresses
        resources.ingresses.forEach((r) => {
            console.log(`creating ${r.kind} ${r.metadata!.name}`);
            network
                .createNamespacedIngress(namespace, r)
                .then(({ body }) => {
                    console.log(`created ${body.kind} ${body.metadata!.name}`);
                })
                .catch(ignore409);
        });
    }

    protected async create(event: ResourceEvent) {
        const resources = this.synthetizer.synth(
            event.object as ApplicationCustomResource
        );
        await this.print(resources);
        await this.apply(resources);
    }

    protected async delete(event: ResourceEvent) {
        const namespace = event.meta.namespace ?? "default";
        const core = this.k8sApi;
        const apps = this.kubeConfig.makeApiClient(k8s.AppsV1Api);
        const network = this.kubeConfig.makeApiClient(k8s.NetworkingV1Api);

        const resources = this.synthetizer.synth(
            event.object as ApplicationCustomResource
        );

        // delete ingresses
        await Promise.all(
            resources.ingresses.map((r) =>
                network.deleteNamespacedIngress(r.metadata!.name!, namespace)
            )
        );

        // delete services
        await Promise.all(
            resources.services.map((r) =>
                core.deleteNamespacedService(r.metadata!.name!, namespace)
            )
        );

        // delete deployments
        await Promise.all(
            resources.deployments.map((r) =>
                apps.deleteNamespacedDeployment(r.metadata!.name!, namespace)
            )
        );

        // delete configMaps
        await Promise.all(
            resources.configMaps.map((r) =>
                core.deleteNamespacedConfigMap(r.metadata!.name!, namespace)
            )
        );
    }
}
