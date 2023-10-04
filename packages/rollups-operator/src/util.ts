import path from "path";
import k8s, {
    V1ConfigMap,
    V1Deployment,
    V1EnvVar,
    V1ObjectMeta,
    V1PodTemplateSpec,
    V1Probe,
    V1Service,
    V1ServiceSpec,
    V1Volume,
    V1VolumeMount,
} from "@kubernetes/client-node";

/**
 * Utility function for mounting volumes
 * @param volume volume to be mounted
 * @returns volume mount
 */
export const mount = (volume: V1Volume) => ({
    at: (
        mountPath: string,
        options?: Pick<
            V1VolumeMount,
            "mountPropagation" | "readOnly" | "subPath" | "subPathExpr"
        >,
    ): V1VolumeMount => ({
        name: volume.name,
        mountPath,
        readOnly: options?.readOnly,
        mountPropagation: options?.mountPropagation,
        subPath: options?.subPath,
        subPathExpr: options?.subPathExpr,
    }),
});

export const service = (
    name: string,
    serviceName: string,
    port: number,
    labels: V1ObjectMeta["labels"],
    selector: V1ServiceSpec["selector"],
): k8s.V1Service => ({
    apiVersion: "v1",
    kind: "Service",
    metadata: { name: `${name}-${serviceName}`, labels },
    spec: {
        type: "ClusterIP",
        ports: [
            {
                name: serviceName,
                port,
                targetPort: port,
                protocol: "TCP",
            },
        ],
        selector,
    },
});

export const deployment = (
    name: string,
    deploymentName: string,
    template: V1PodTemplateSpec,
    labels: V1ObjectMeta["labels"],
    replicas: number = 1,
): V1Deployment => ({
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: { name: `${name}-${deploymentName}`, labels },
    spec: {
        replicas,
        selector: { matchLabels: template.metadata?.labels },
        strategy: { type: "Recreate" },
        template,
    },
});

// utility constructor of env vars from configMap key value
export const env = (name: string) => ({
    fromKey: (key: string) => ({
        of: (configMapName: string): V1EnvVar => ({
            name,
            valueFrom: {
                configMapKeyRef: {
                    name: configMapName,
                    key,
                },
            },
        }),
    }),
});

// utility function to define env vars for postgres
const pgEnv = (
    mount: V1VolumeMount,
    secretName: string,
    names: Record<string, string>,
): k8s.V1EnvVar[] =>
    Object.entries(names).map(([key, name]) => ({
        name,
        valueFrom:
            key !== "passwordFile"
                ? { secretKeyRef: { key, name: secretName } }
                : undefined,
        value:
            key === "passwordFile" ? `${mount.mountPath}/password` : undefined,
    }));

export const database = (name: string, secretName: string) => {
    // define a volume which maps the secret password key (and only that) to a file
    const v: V1Volume = {
        name,
        secret: {
            secretName,
            // items: [{ key: "password", path: "password", mode: 0o600 }], // https://github.com/cartesi/rollups-node/issues/55
            items: [{ key: "password", path: "password", mode: 0o644 }],
        },
    };

    // mount the volume at /var/run/secrets
    const m = mount(v).at(`/var/run/secrets/${name}`, { readOnly: false });

    const env = (
        naming: "std" | "rollups",
        database?: string,
    ): k8s.V1EnvVar[] => {
        switch (naming) {
            case "std":
                // define a set of env vars using standard names as defined by libpq (https://www.postgresql.org/docs/current/libpq-envars.html)
                return pgEnv(m, secretName, {
                    hostname: "PGHOST",
                    port: "PGPORT",
                    database: "PGDATABASE",
                    username: "PGUSER",
                    // passwordFile: "PGPASSFILE", // XXX: https://github.com/cartesi/rollups-node/issues/55
                    password: "PGPASSWORD",
                });
            case "rollups":
                // define a set of env vars using env names used by rollups services, database var is direct value
                return [
                    ...pgEnv(m, secretName, {
                        hostname: "POSTGRES_HOSTNAME",
                        port: "POSTGRES_PORT",
                        username: "POSTGRES_USER",
                        passwordFile: "POSTGRES_PASSWORD_FILE",
                    }),
                    { name: "POSTGRES_DB", value: database },
                ];
        }
    };

    return {
        volume: v,
        mount: m,
        env,
    };
};

export const file = (
    name: string,
    labels: V1ObjectMeta["labels"],
    mountPath: string,
    filename: string,
    object: any,
) => {
    const configMap: V1ConfigMap = {
        apiVersion: "v1",
        kind: "ConfigMap",
        metadata: { name, labels },
        data: {
            [filename]: JSON.stringify(object),
        },
    };

    const volume = {
        name: name,
        configMap: { name, items: [{ key: filename, path: filename }] },
    };

    return {
        configMap,
        volume,
        mount: mount(volume).at(mountPath, { readOnly: true }),
        absolutePath: path.join(mountPath, filename),
    };
};

// utility constructor of volumes from configMap key file
export const volume = (name: string) => ({
    fromKey: (key: string) => ({
        of: (configMapName: string) => ({
            mountedAt: (mountPath: string) => {
                const v: V1Volume = {
                    name,
                    configMap: {
                        name: configMapName,
                        items: [{ key, path: key }],
                    },
                };
                return {
                    volume: v,
                    mount: mount(v).at(mountPath, { readOnly: true }),
                    absolutePath: path.join(mountPath, key),
                };
            },
        }),
    }),
});

export const emptyVolume = (name: string) => ({
    mountedAt: (mountPath: string) => {
        const v: V1Volume = { name, emptyDir: {} };
        return {
            volume: v,
            mount: mount(v).at(mountPath),
        };
    },
});

export const grpcProbe = (port: number): V1Probe => ({
    grpc: { port },
    initialDelaySeconds: 3,
});

export const httpProbe = (port: number): V1Probe => ({
    httpGet: { port, path: "/healthz" },
    initialDelaySeconds: 3,
});
