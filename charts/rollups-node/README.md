# rollups-node-chart

# Package for Cartesi Rollups Nodes

![Version: 1.0.2-0](https://img.shields.io/badge/Version-1.0.2--0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Refer to the [official documentation](https://docs.cartesi.io/cartesi-rollups/overview/) for more information about Cartesi Rollups.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| endersonmaia | <endersonmaia@gmail.com> | <https://github.com/endersonmaia> |
| oap75 | <omid.asadpoor36@gmail.com> | <https://github.com/oap75> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 12.1.9 |
| https://charts.bitnami.com/bitnami | redis | 17.3.11 |

## TL;DR

```console
helm install my-node oci://docker.io/cartesi/rollups-node-chart
```

### OR

```console
helm install my-node oci://ghcr.io/cartesi/charts/rollups-node-chart
```

## Introduction

This chart bootstraps [Cartesi Rollups Nodes](https://docs.cartesi.io/cartesi-rollups/overview/) deployments on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8.0+
- PersistentVolume provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-node`:

```console
helm install my-node oci://docker.io/cartesi/rollups-node-chart
```

OR

```console
helm install my-node oci://ghcr.io/cartesi/charts/rollups-node-chart
```

The command deploys Cartesi Rollups Nodes; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-node` deployment:

```console
helm delete my-node
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dapp.blockHash | string | `nil` | the block hash of the block where the dapp was deployed (REQUIRED) |
| dapp.blockNumber | string | `nil` | the block number of the block where the dapp was deployed (REQUIRED) |
| dapp.contractAddress | string | `nil` | the contract address of the dapp deployed on the blockchain (REQUIRED) |
| dapp.httpProvider | string | `nil` | the URL for the http:// endpoint of the provider (REQUIRED) |
| dapp.image | string | `nil` | the complete image name, e.g. "cartesi/dapp:echo-python-0.8.0-server" (REQUIRED) |
| dapp.mnemonic | object | `{"secretRef":null,"value":null}` | mnemonic defines the configuration for the mnemonic use value or secretRef, never both |
| dapp.mnemonic.secretRef | string | `nil` | the name of the secret that should exist in the same namespace the secret MUST contain a mnemonic element like `{"mnemonic":"twelve words ..."}` |
| dapp.mnemonic.value | string | `nil` | the 12 words mnemonic for the wallet a secret will be created with its content |
| dapp.network | string | `nil` | the name of the network the dapp is deployed on (REQUIRED) Available options are:   - mainnet   - optimism   - optimism-goerli   - arbitrum   - arbitrum-goerli   - localhost   - sepolia |
| dapp.transactionHash | string | `nil` | dapp.transactionHash is the transaction hash of the transaction that deployed the dapp (REQUIRED) |
| dapp.wsProvider | string | `nil` | the URL for the ws:// endpoint of the provider (REQUIRED) |
| endpoints.affinity | object | `{}` | Affinity for pods assignment |
| endpoints.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the endpoints pod(s) # |
| endpoints.graphqlServer.args | list | `[]` | Override default container args (useful when using custom images) |
| endpoints.graphqlServer.command | list | `[]` | Override default container command (useful when using custom images) |
| endpoints.graphqlServer.extraArgs | list | `[]` | Extra arguments for graphqlServer |
| endpoints.graphqlServer.extraEnvVars | list | `[]` | Array with extra environment variables to add to endpoints.graphqlServer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| endpoints.graphqlServer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for graphqlServer container |
| endpoints.graphqlServer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for graphqlServer container |
| endpoints.graphqlServer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the endpoints.graphqlServer container(s) |
| endpoints.graphqlServer.healthCheck.enabled | bool | `true` | enable/disable healthcheck for graphqlServer |
| endpoints.graphqlServer.healthCheck.port | int | `8085` | define healthcheck port for graphqlServer |
| endpoints.graphqlServer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-graphql-server","tag":null}` | Set the graphqlServer docker image |
| endpoints.graphqlServer.ingress.annotations | object | `{}` | defines extra anotations specifically for the endpoints.graphqlServer.service |
| endpoints.graphqlServer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| endpoints.graphqlServer.resources | object | `{}` | Set graphqlServer container resources |
| endpoints.graphqlServer.securityContext | object | `{}` | Set graphqlServer container Security Context |
| endpoints.graphqlServer.service.port | int | `4000` | graphqlServer service port |
| endpoints.graphqlServer.service.type | string | `"ClusterIP"` | graphqlServer service type |
| endpoints.initContainers | list | `[]` | Add additional init containers to the endpoints pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| endpoints.inspectServer.args | list | `[]` | Override default container args (useful when using custom images) |
| endpoints.inspectServer.command | list | `[]` | Override default container command (useful when using custom images) |
| endpoints.inspectServer.extraArgs | list | `[]` | Extra arguments for inspectServer |
| endpoints.inspectServer.extraEnvVars | list | `[]` | extraEnvVars Array with extra environment variables to add to endpoints.inspectServer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| endpoints.inspectServer.extraEnvVarsCM | string | `""` | extraEnvVarsCM Name of existing ConfigMap containing extra env vars for inspectServer container |
| endpoints.inspectServer.extraEnvVarsSecret | string | `""` | extraEnvVarsSecret Name of existing Secret containing extra env vars for inspectServer container |
| endpoints.inspectServer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the endpoints.inspectServer container(s) |
| endpoints.inspectServer.healthCheck.enabled | bool | `true` | enable/disable healthcheck for inspectServer |
| endpoints.inspectServer.healthCheck.port | int | `8084` | define healthcheck port for inspectServer |
| endpoints.inspectServer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-inspect-server","tag":null}` | Set the inspectServer docker image |
| endpoints.inspectServer.ingress.annotations | object | `{}` | defines extra anotations specifically for the endpoints.inspectServer.service |
| endpoints.inspectServer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| endpoints.inspectServer.resources | object | `{}` | Set inspectServer container resources |
| endpoints.inspectServer.securityContext | object | `{}` | Set inspectServer container Security Context |
| endpoints.inspectServer.service.port | int | `5005` | inspectServer service port |
| endpoints.inspectServer.service.type | string | `"ClusterIP"` | inspectServer service type |
| endpoints.nodeSelector | object | `{}` | Node labels for pods assignment |
| endpoints.podAnnotations | object | `{}` | Annotations for endpoints replicas pods |
| endpoints.podSecurityContext | object | `{}` | Set endpoints replicas pod's Security Context |
| endpoints.replicaCount | int | `1` | Number of endpoints replicas to deploy |
| endpoints.tolerations | list | `[]` | Tolerations for pods assignment |
| extraDeploy | list | `[]` | Array of extra objects to deploy with the release |
| fullnameOverride | string | `""` | String to fully override name |
| global.image.registry | string | `"docker.io"` | Global Docker image registry |
| global.image.tag | string | `"1.0.2"` | Global Docker Image tag |
| image.pullPolicy | string | `"Always"` | Pullpolicy for Docker Images |
| image.pullSecrets | list | `[]` | Cartesi Rollups Validator Nodes pull secrets |
| ingress.addReleaseNameAsHost | bool | `false` | dditional rules[].host |
| ingress.annotations | object | `{}` | defines the annotations for ingresses |
| ingress.enabled | bool | `false` | Specifies whether a Ingress should be created |
| ingress.ingressClassName | string | `nil` | defines the IngressClass to be used If not set, the default class will be used https://kubernetes.io/docs/concepts/services-networking/ingress/#default-ingress-class |
| ingress.subDomain | string | `"local"` | Ingress Sub domain name |
| nameOverride | string | `""` | String to partially override  name |
| postgresql.auth | object | `{"database":"rollups","password":"rollups","port":5432,"username":"rollups"}` | Set bitnami postgreSQL`username`, `password`,`database` |
| postgresql.enabled | bool | `true` | Use bitnami postgreSQL pod. |
| postgresql.image.tag | string | `"13.9.0-debian-11-r27"` | bitnami postgreSQL docker image tag. |
| redis.architecture | string | `"standalone"` | Redis&reg; architecture. Allowed values: `standalone` or `replication` |
| redis.auth.enabled | bool | `false` | Redis&reg; Enable password authentication |
| redis.clusterEndpoints | list | `[]` | redis.clusterEndpoints: e.g.: [ "redis://localhost:6379" ] REQUIRED if you disabled redis and your redis is cluster |
| redis.enabled | bool | `true` | Use bitnami Redis&reg; pod. |
| redis.endpoint | string | `nil` | redis.endpoint: e.g.: redis://localhost:6379 REQUIRED if you disabled redis and your redis is standalone |
| redis.image.tag | string | `"6.2-debian-11"` | Redis&reg; docker image tag. |
| redis.metrics.enabled | bool | `true` | sidecar prometheus exporter to expose Redis&reg; metrics |
| serverManager.advanceRunner.args | list | `[]` | Override default container args (useful when using custom images) |
| serverManager.advanceRunner.command | list | `[]` | verride default container command (useful when using custom images) |
| serverManager.advanceRunner.extraArgs | list | `[]` | Extra arguments for advanceRunner |
| serverManager.advanceRunner.extraEnvVars | list | `[]` | Array with extra environment variables to add to serverManager.advanceRunner container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| serverManager.advanceRunner.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for advanceRunner container |
| serverManager.advanceRunner.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for advanceRunner container |
| serverManager.advanceRunner.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the serverManager.advanceRunner container(s) |
| serverManager.advanceRunner.healthCheck.enabled | bool | `true` | enable/disable health check for advanceRunner |
| serverManager.advanceRunner.healthCheck.port | int | `8083` | define the health check port for advanceRunner |
| serverManager.advanceRunner.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-advance-runner","tag":null}` | Set the advanceRunner docker image |
| serverManager.advanceRunner.logLevel | string | `"info"` | Set RUST_LOG env, can be trace, debug, info, warn, error, or off. |
| serverManager.advanceRunner.resources | object | `{}` | Set advanceRunner container resources |
| serverManager.advanceRunner.securityContext | object | `{}` | Set advanceRunner container Security Context |
| serverManager.affinity | object | `{}` | Affinity for pods assignment |
| serverManager.args | list | `["server-manager","--manager-address=0.0.0.0:5001"]` | Override default container args (useful when using custom images) |
| serverManager.command | list | `[]` | Override default container command (useful when using custom images) |
| serverManager.extraArgs | list | `[]` | Extra arguments for serverManager |
| serverManager.extraEnvVars | list | `[]` | Array with extra environment variables to add to serverManager container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| serverManager.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for serverManager container |
| serverManager.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for serverManager container |
| serverManager.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the serverManager container(s) |
| serverManager.extraVolumes | list | `[]` |  |
| serverManager.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-indexer","tag":null}` | Override the image defined in dapp.image |
| serverManager.initContainers | list | `[]` | additional init containers to the ServerManager pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| serverManager.logLevel | string | `"info"` | set SERVER_MANAGER_LOG_LEVEL env, can be set to trace, debug, info, warning, error, and fatal. |
| serverManager.nodeSelector | object | `{}` | Node labels for pods assignment |
| serverManager.podAnnotations | object | `{}` | Annotations for serverManager replicas pods |
| serverManager.podSecurityContext | object | `{}` | Set serverManager replicas pod's Security Context |
| serverManager.remoteCartesiMachine.logLevel | string | `nil` | Set REMOTE_CARTESI_MACHINE_LOG_LEVEL env, can be set to trace, debug, info, warning, error, and fatal. defaults to serverManager.logLevel unless you provide a different value |
| serverManager.resources | object | `{}` | Set serverManager container resources |
| serverManager.securityContext | object | `{}` | Set serverManager container Security Context |
| serverManager.service.port | int | `5001` | serverManager service port |
| serverManager.service.type | string | `"ClusterIP"` | serverManager service type |
| serverManager.shareSnapshotFromImage | bool | `true` | Share cartesi-machine snpashot from dapp.image to advanceRunner and serverManager The image must be located at /var/opt/cartesi/share/machine-snapshots/0_0 |
| serverManager.tolerations | list | `[]` | Tolerations for pods assignment |
| serviceAccount.annotations | object | `{}` | defines the annotations to add to the service account |
| serviceAccount.create | bool | `false` | defines whether a service account should be created |
| serviceAccount.name | string | `""` | defines the name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| validator.affinity | object | `{}` | Affinity for validator pods assignment |
| validator.dispatcher.args | list | `[]` | Override default container args (useful when using custom images) |
| validator.dispatcher.command | list | `[]` | Override default container command (useful when using custom images) |
| validator.dispatcher.extraArgs | list | `[]` | Extra arguments for dispatcher |
| validator.dispatcher.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.dispatcher container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| validator.dispatcher.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for dispatcher container # |
| validator.dispatcher.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for dispatcher container # |
| validator.dispatcher.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the dispatcher container(s) |
| validator.dispatcher.healthCheck.enabled | bool | `true` | enable/disable health check for dispatcher |
| validator.dispatcher.healthCheck.port | int | `8081` | define the health check port for dispatcher |
| validator.dispatcher.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-dispatcher","tag":null}` | Set the dispatcher docker image |
| validator.dispatcher.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| validator.dispatcher.resources | object | `{}` | Set dispatcher container resources |
| validator.dispatcher.securityContext | object | `{}` | Set dispatcher container Security Context |
| validator.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the validator pod(s) |
| validator.indexer.args | list | `[]` | Override default container args (useful when using custom images) |
| validator.indexer.command | list | `[]` | Override default container command (useful when using custom images) |
| validator.indexer.extraArgs | list | `[]` | Extra arguments for indexer |
| validator.indexer.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.indexer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| validator.indexer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for indexer container # |
| validator.indexer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for indexer container # |
| validator.indexer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the indexer container(s) # |
| validator.indexer.healthCheck.enabled | bool | `true` | enable/disable health check for indexer |
| validator.indexer.healthCheck.port | int | `8082` | define the health check port for indexer |
| validator.indexer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-indexer","tag":null}` | Set the indexer docker image |
| validator.indexer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| validator.indexer.resources | object | `{}` | Set indexer container resources |
| validator.indexer.securityContext | object | `{}` | Set indexer container Security Context |
| validator.initContainers | list | `[]` | add additional init containers to the validator-node pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| validator.localnode.anvil.args | list | `["anvil","--block-time","5","--load-state","/opt/cartesi/share/deployments/anvil_state.json"]` | Override default container args (useful when using custom images) |
| validator.localnode.anvil.command | list | `[]` | Override default container command (useful when using custom images) |
| validator.localnode.anvil.extraArgs | list | `[]` | Extra arguments for anvil |
| validator.localnode.anvil.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.anvil container e.g: extraEnvVars:   - name: FOO     value: "bar" |
| validator.localnode.anvil.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for anvil container |
| validator.localnode.anvil.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for anvil container |
| validator.localnode.anvil.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the anvil container(s) # |
| validator.localnode.anvil.image | object | `{"digest":null,"registry":null,"repository":"sunodo/anvil","tag":"2.0.0"}` | Set the anvil docker image |
| validator.localnode.anvil.resources | object | `{}` | Set anvil container resources |
| validator.localnode.anvil.securityContext | object | `{}` | Set anvil container Security Context |
| validator.localnode.deployer.args | list | `[]` | Override default container args (useful when using custom images) |
| validator.localnode.deployer.command | list | `[]` | Override default container command (useful when using custom images) |
| validator.localnode.deployer.extraArgs | list | `[]` | Extra arguments for deployer |
| validator.localnode.deployer.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.deployer container e.g: extraEnvVars:   - name: FOO     value: "bar" |
| validator.localnode.deployer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for deployer container |
| validator.localnode.deployer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for deployer container |
| validator.localnode.deployer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the deployer container(s) |
| validator.localnode.deployer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-cli","tag":null}` | Set the deployer docker image |
| validator.localnode.deployer.resources | object | `{}` | Set deployer container resources |
| validator.localnode.deployer.securityContext | object | `{}` | Set deployer container Security Context |
| validator.localnode.enabled | bool | `false` | Specify whether to use localnode or not |
| validator.localnode.service.port | int | `8545` | localnode service port |
| validator.localnode.service.type | string | `"ClusterIP"` | localnode service type |
| validator.localnode.storage.blockchainData | object | `{"size":"2Gi","storageClass":null}` | PVC for localnode blockchain data |
| validator.localnode.storage.blockchainData.size | string | `"2Gi"` | Persistent Volume storage size for localnode blockchain data |
| validator.localnode.storage.blockchainData.storageClass | string | `nil` | Persistent Volume storage class for localnode blockchain data If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner |
| validator.localnode.storage.deployments | object | `{"size":"1Gi","storageClass":null}` | PVC for loaclnode rollups deployment |
| validator.localnode.storage.deployments.size | string | `"1Gi"` | Persistent Volume storage size for localnode rollups deployment |
| validator.localnode.storage.deployments.storageClass | string | `nil` | Persistent Volume storage class for localnode rollups deployment If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner |
| validator.localnode.storage.machineSnapshots | object | `{"size":"2Gi","storageClass":null}` | PVC for localnode shared machine snapshot |
| validator.localnode.storage.machineSnapshots.size | string | `"2Gi"` | Persistent Volume storage size for localnode shared machine snapshot |
| validator.localnode.storage.machineSnapshots.storageClass | string | `nil` | Persistent Volume storage class for localnode shared machine snapshot If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner |
| validator.nodeSelector | object | `{}` | Node labels for validator pods assignment |
| validator.podAnnotations | object | `{}` | Annotations for Validator replicas pods |
| validator.podSecurityContext | object | `{}` | validator replicas pod's Security Context |
| validator.stateServer.args | list | `[]` | Override default container args (useful when using custom images) |
| validator.stateServer.command | list | `[]` | Override default container command (useful when using custom images) |
| validator.stateServer.extraArgs | list | `[]` | Extra arguments for StateServer |
| validator.stateServer.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.stateServer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| validator.stateServer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for stateServer container |
| validator.stateServer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for stateServer container |
| validator.stateServer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the stateServer container(s) |
| validator.stateServer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-state-server","tag":null}` | Set the stateServer docker image |
| validator.stateServer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| validator.stateServer.resources | object | `{}` | Set StateServer container resources |
| validator.stateServer.securityContext | object | `{}` | Set StateServer container Security Context |
| validator.tolerations | list | `[]` | Tolerations for validator pods assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-node \
  --set postgresql.auth.password=secretpassword \
    oci://docker.io/cartesi/rollups-node-chart
```

The above command sets the bitnami PostgreSQL server password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-node -f values.yaml oci://docker.io/cartesi/rollups-node-chart
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### Rolling VS Immutable tags

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Cartesi will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

By default, the chart uses StorageClass named `standard` for the [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). The volume is created using dynamic volume provisioning. If a your default StorageClass name is different, specify it during installation.

### Setting Pod's affinity

This chart allows you to set your custom affinity. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)