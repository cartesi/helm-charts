# rollups-node-chart

# Package for Cartesi Rollups Nodes

![Version: 1.1.0-0](https://img.shields.io/badge/Version-1.1.0--0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| dispatcher.affinity | object | `{}` | Affinity for validator pods assignment |
| dispatcher.args | list | `[]` | Override default container args (useful when using custom images) |
| dispatcher.command | list | `["cartesi-rollups-dispatcher"]` | Override default container command (useful when using custom images) |
| dispatcher.extraArgs | list | `[]` | Extra arguments for dispatcher |
| dispatcher.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.dispatcher container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| dispatcher.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for dispatcher container # |
| dispatcher.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for dispatcher container # |
| dispatcher.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the dispatcher container(s) |
| dispatcher.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the validator pod(s) |
| dispatcher.healthCheck.enabled | bool | `true` | enable/disable health check for dispatcher |
| dispatcher.healthCheck.port | int | `8081` | define the health check port for dispatcher |
| dispatcher.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Set the dispatcher docker image |
| dispatcher.initContainers | list | `[]` | add additional init containers to the dispatcher pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| dispatcher.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| dispatcher.nodeSelector | object | `{}` | Node labels for validator pods assignment |
| dispatcher.podAnnotations | object | `{}` | Annotations for Validator replicas pods |
| dispatcher.podSecurityContext | object | `{}` | validator replicas pod's Security Context |
| dispatcher.resources | object | `{}` | Set dispatcher container resources |
| dispatcher.securityContext | object | `{}` | Set dispatcher container Security Context |
| dispatcher.tolerations | list | `[]` | Tolerations for validator pods assignment |
| extraDeploy | list | `[]` | Array of extra objects to deploy with the release |
| fullnameOverride | string | `""` | String to fully override name |
| global.image.registry | string | `"docker.io"` | Global Docker image registry |
| global.image.tag | string | `"1.1.0"` | Global Docker Image tag |
| graphqlServer.affinity | object | `{}` | Affinity for pods assignment |
| graphqlServer.args | list | `[]` | Override default container args (useful when using custom images) |
| graphqlServer.command | list | `["cartesi-rollups-graphql-server"]` | Override default container command (useful when using custom images) |
| graphqlServer.extraArgs | list | `[]` | Extra arguments for graphqlServer |
| graphqlServer.extraEnvVars | list | `[]` | Array with extra environment variables to add to endpoints.graphqlServer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| graphqlServer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for graphqlServer container |
| graphqlServer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for graphqlServer container |
| graphqlServer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the endpoints.graphqlServer container(s) |
| graphqlServer.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the endpoints pod(s) # |
| graphqlServer.healthCheck.enabled | bool | `true` | enable/disable healthcheck for graphqlServer |
| graphqlServer.healthCheck.port | int | `8085` | define healthcheck port for graphqlServer |
| graphqlServer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Set the graphqlServer docker image |
| graphqlServer.ingress.annotations | object | `{}` | defines extra anotations specifically for the endpoints.graphqlServer.service |
| graphqlServer.initContainers | list | `[]` | Add additional init containers to the endpoints pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| graphqlServer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| graphqlServer.nodeSelector | object | `{}` | Node labels for pods assignment |
| graphqlServer.podAnnotations | object | `{}` | Annotations for endpoints replicas pods |
| graphqlServer.podSecurityContext | object | `{}` | Set endpoints replicas pod's Security Context |
| graphqlServer.replicaCount | int | `1` | Number of endpoints replicas to deploy |
| graphqlServer.resources | object | `{}` | Set graphqlServer container resources |
| graphqlServer.securityContext | object | `{}` | Set graphqlServer container Security Context |
| graphqlServer.service.port | int | `4000` | graphqlServer service port |
| graphqlServer.service.type | string | `"ClusterIP"` | graphqlServer service type |
| graphqlServer.tolerations | list | `[]` | Tolerations for pods assignment |
| image.pullPolicy | string | `"Always"` | Pullpolicy for Docker Images |
| image.pullSecrets | list | `[]` | Cartesi Rollups Validator Nodes pull secrets |
| indexer.affinity | object | `{}` | Affinity for validator pods assignment |
| indexer.args | list | `[]` | Override default container args (useful when using custom images) |
| indexer.command | list | `["cartesi-rollups-indexer"]` | Override default container command (useful when using custom images) |
| indexer.extraArgs | list | `[]` | Extra arguments for indexer |
| indexer.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.indexer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| indexer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for indexer container # |
| indexer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for indexer container # |
| indexer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the indexer container(s) # |
| indexer.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the validator pod(s) |
| indexer.healthCheck.enabled | bool | `true` | enable/disable health check for indexer |
| indexer.healthCheck.port | int | `8082` | define the health check port for indexer |
| indexer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Set the indexer docker image |
| indexer.initContainers | list | `[]` | add additional init containers to the validator-node pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| indexer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| indexer.nodeSelector | object | `{}` | Node labels for validator pods assignment |
| indexer.podAnnotations | object | `{}` | Annotations for Validator replicas pods |
| indexer.podSecurityContext | object | `{}` | validator replicas pod's Security Context |
| indexer.resources | object | `{}` | Set indexer container resources |
| indexer.securityContext | object | `{}` | Set indexer container Security Context |
| indexer.tolerations | list | `[]` | Tolerations for validator pods assignment |
| ingress.addReleaseNameAsHost | bool | `false` | dditional rules[].host |
| ingress.annotations | object | `{}` | defines the annotations for ingresses |
| ingress.enabled | bool | `false` | Specifies whether a Ingress should be created |
| ingress.ingressClassName | string | `nil` | defines the IngressClass to be used If not set, the default class will be used https://kubernetes.io/docs/concepts/services-networking/ingress/#default-ingress-class |
| ingress.subDomain | string | `"local"` | Ingress Sub domain name |
| inspectServer.affinity | object | `{}` | Affinity for pods assignment |
| inspectServer.args | list | `[]` | Override default container args (useful when using custom images) |
| inspectServer.command | list | `["cartesi-rollups-inspect-server"]` | Override default container command (useful when using custom images) |
| inspectServer.extraArgs | list | `[]` | Extra arguments for inspectServer |
| inspectServer.extraEnvVars | list | `[]` | extraEnvVars Array with extra environment variables to add to endpoints.inspectServer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| inspectServer.extraEnvVarsCM | string | `""` | extraEnvVarsCM Name of existing ConfigMap containing extra env vars for inspectServer container |
| inspectServer.extraEnvVarsSecret | string | `""` | extraEnvVarsSecret Name of existing Secret containing extra env vars for inspectServer container |
| inspectServer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the endpoints.inspectServer container(s) |
| inspectServer.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the endpoints pod(s) # |
| inspectServer.healthCheck.enabled | bool | `true` | enable/disable healthcheck for inspectServer |
| inspectServer.healthCheck.port | int | `8084` | define healthcheck port for inspectServer |
| inspectServer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Set the inspectServer docker image |
| inspectServer.ingress.annotations | object | `{}` | defines extra anotations specifically for the endpoints.inspectServer.service |
| inspectServer.initContainers | list | `[]` | Add additional init containers to the endpoints pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| inspectServer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| inspectServer.nodeSelector | object | `{}` | Node labels for pods assignment |
| inspectServer.podAnnotations | object | `{}` | Annotations for endpoints replicas pods |
| inspectServer.podSecurityContext | object | `{}` | Set endpoints replicas pod's Security Context |
| inspectServer.replicaCount | int | `1` | Number of endpoints replicas to deploy |
| inspectServer.resources | object | `{}` | Set inspectServer container resources |
| inspectServer.securityContext | object | `{}` | Set inspectServer container Security Context |
| inspectServer.service.port | int | `5005` | inspectServer service port |
| inspectServer.service.type | string | `"ClusterIP"` | inspectServer service type |
| inspectServer.tolerations | list | `[]` | Tolerations for pods assignment |
| localnode.affinity | object | `{}` | Affinity for localnode pod assignment |
| localnode.anvil.args | list | `["anvil","--block-time","5","--load-state","/opt/cartesi/share/deployments/anvil_state.json"]` | Override default container args (useful when using custom images) |
| localnode.anvil.command | list | `[]` | Override default container command (useful when using custom images) |
| localnode.anvil.extraArgs | list | `[]` | Extra arguments for anvil |
| localnode.anvil.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.anvil container e.g: extraEnvVars:   - name: FOO     value: "bar" |
| localnode.anvil.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for anvil container |
| localnode.anvil.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for anvil container |
| localnode.anvil.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the anvil container(s) # |
| localnode.anvil.image | object | `{"digest":null,"registry":null,"repository":"sunodo/anvil","tag":"3.0.0"}` | Set the anvil docker image |
| localnode.anvil.resources | object | `{}` | Set anvil container resources |
| localnode.anvil.securityContext | object | `{}` | Set anvil container Security Context |
| localnode.deployer.args | list | `[]` | Override default container args (useful when using custom images) |
| localnode.deployer.command | list | `[]` | Override default container command (useful when using custom images) |
| localnode.deployer.extraArgs | list | `[]` | Extra arguments for deployer |
| localnode.deployer.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.deployer container e.g: extraEnvVars:   - name: FOO     value: "bar" |
| localnode.deployer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for deployer container |
| localnode.deployer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for deployer container |
| localnode.deployer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the deployer container(s) |
| localnode.deployer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-cli","tag":"1.0.2"}` | Set the deployer docker image |
| localnode.deployer.resources | object | `{}` | Set deployer container resources |
| localnode.deployer.securityContext | object | `{}` | Set deployer container Security Context |
| localnode.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the validator pod(s) |
| localnode.initContainers | list | `[]` | add additional init containers to the localnode pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| localnode.nodeSelector | object | `{}` | Node labels for localnode pod assignment |
| localnode.podAnnotations | object | `{}` | Annotations for Validator replicas pods |
| localnode.podSecurityContext | object | `{}` | localnode replicas pod's Security Context |
| localnode.service.port | int | `8545` | localnode service port |
| localnode.service.type | string | `"ClusterIP"` | localnode service type |
| localnode.storage.blockchainData | object | `{"size":"2Gi","storageClass":null}` | PVC for localnode blockchain data |
| localnode.storage.blockchainData.size | string | `"2Gi"` | Persistent Volume storage size for localnode blockchain data |
| localnode.storage.blockchainData.storageClass | string | `nil` | Persistent Volume storage class for localnode blockchain data If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner |
| localnode.storage.deployments | object | `{"size":"1Gi","storageClass":null}` | PVC for loaclnode rollups deployment |
| localnode.storage.deployments.size | string | `"1Gi"` | Persistent Volume storage size for localnode rollups deployment |
| localnode.storage.deployments.storageClass | string | `nil` | Persistent Volume storage class for localnode rollups deployment If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner |
| localnode.storage.machineSnapshots | object | `{"size":"2Gi","storageClass":null}` | PVC for localnode shared machine snapshot |
| localnode.storage.machineSnapshots.size | string | `"2Gi"` | Persistent Volume storage size for localnode shared machine snapshot |
| localnode.storage.machineSnapshots.storageClass | string | `nil` | Persistent Volume storage class for localnode shared machine snapshot If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner |
| localnode.tolerations | list | `[]` | Tolerations for localnode pod assignment |
| nameOverride | string | `""` | String to partially override  name |
| postgresql.auth | object | `{"database":"rollups","password":"rollups","port":5432,"username":"rollups"}` | Set bitnami postgreSQL`username`, `password`,`database`. |
| postgresql.enabled | bool | `true` | Use bitnami postgreSQL pod. |
| postgresql.endpoint | object | `{"secretRef":null,"value":null}` | Define an external Postgresql endpoint |
| postgresql.endpoint.secretRef | string | `nil` | Define an existing secret name. REQUIRED if you don't want to define an endpoint value. |
| postgresql.endpoint.value | string | `nil` | Connection detail like postgres://host:pass@host:port/db. REQUIRED if you don't have an existing secret. |
| postgresql.image.tag | string | `"13.9.0-debian-11-r27"` | bitnami postgreSQL docker image tag. |
| redis.architecture | string | `"standalone"` | Redis&reg; architecture. Allowed values: `standalone` or `replication` |
| redis.auth.enabled | bool | `false` | Redis&reg; Enable password authentication |
| redis.clusterEndpoints | list | `[]` | redis.clusterEndpoints: e.g.: [ "redis://localhost:6379" ] REQUIRED if you disabled redis and your redis is cluster |
| redis.enabled | bool | `true` | Use bitnami Redis&reg; pod. |
| redis.endpoint | string | `nil` | redis.endpoint: e.g.: redis://localhost:6379 REQUIRED if you disabled redis and your redis is standalone |
| redis.image.tag | string | `"6.2-debian-11"` | Redis&reg; docker image tag. |
| redis.metrics.enabled | bool | `true` | sidecar prometheus exporter to expose Redis&reg; metrics |
| serverManager.advanceRunner.args | list | `[]` | Override default container args (useful when using custom images) |
| serverManager.advanceRunner.command | list | `["cartesi-rollups-advance-runner"]` | verride default container command (useful when using custom images) |
| serverManager.advanceRunner.extraArgs | list | `[]` | Extra arguments for advanceRunner |
| serverManager.advanceRunner.extraEnvVars | list | `[]` | Array with extra environment variables to add to serverManager.advanceRunner container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| serverManager.advanceRunner.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for advanceRunner container |
| serverManager.advanceRunner.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for advanceRunner container |
| serverManager.advanceRunner.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the serverManager.advanceRunner container(s) |
| serverManager.advanceRunner.healthCheck.enabled | bool | `true` | enable/disable health check for advanceRunner |
| serverManager.advanceRunner.healthCheck.port | int | `8083` | define the health check port for advanceRunner |
| serverManager.advanceRunner.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Set the advanceRunner docker image |
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
| serverManager.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Override the image defined in dapp.image |
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
| stateServer.affinity | object | `{}` | Affinity for validator pods assignment |
| stateServer.args | list | `[]` | Override default container args (useful when using custom images) |
| stateServer.command | list | `["cartesi-rollups-state-server"]` | Override default container command (useful when using custom images) |
| stateServer.extraArgs | list | `[]` | Extra arguments for StateServer |
| stateServer.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.stateServer container # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| stateServer.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for stateServer container |
| stateServer.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for stateServer container |
| stateServer.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the stateServer container(s) |
| stateServer.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the validator pod(s) |
| stateServer.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Set the stateServer docker image |
| stateServer.initContainers | list | `[]` | add additional init containers to the validator-node pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| stateServer.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| stateServer.nodeSelector | object | `{}` | Node labels for validator pods assignment |
| stateServer.podAnnotations | object | `{}` | Annotations for Validator replicas pods |
| stateServer.podSecurityContext | object | `{}` | validator replicas pod's Security Context |
| stateServer.resources | object | `{}` | Set StateServer container resources |
| stateServer.securityContext | object | `{}` | Set StateServer container Security Context |
| stateServer.service.port | int | `50051` | stateServer service port |
| stateServer.service.type | string | `"ClusterIP"` | stateServer service type |
| stateServer.tolerations | list | `[]` | Tolerations for validator pods assignment |

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