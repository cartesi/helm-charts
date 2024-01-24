# rollups-node-chart

# Package for Cartesi Rollups Nodes

![Version: 1.3.0-0](https://img.shields.io/badge/Version-1.3.0--0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Refer to the [official documentation](https://docs.cartesi.io/cartesi-rollups/overview/) for more information about Cartesi Rollups.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| endersonmaia | <endersonmaia@gmail.com> | <https://github.com/endersonmaia> |
| oap75 | <omid.asadpoor36@gmail.com> | <https://github.com/oap75> |

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
- [Helm 3.8.0+](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

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
| dapp.image | string | `nil` | the complete image name, e.g. "cartesi/dapp:echo-python-0.8.0-server" (REQUIRED) |
| dapp.network | string | `nil` | the name of the network the dapp is deployed on (REQUIRED) Available options are:   - mainnet   - optimism   - optimism-goerli   - arbitrum   - arbitrum-goerli   - localhost   - sepolia |
| extraDeploy | list | `[]` | Array of extra objects to deploy with the release |
| fullnameOverride | string | `""` | String to fully override name |
| global.image.registry | string | `"docker.io"` | Global Docker image registry |
| global.image.tag | string | `"1.3.0"` | Global Docker Image tag |
| image.pullPolicy | string | `"Always"` | Pullpolicy for Docker Images |
| image.pullSecrets | list | `[]` | Cartesi Rollups Validator Nodes pull secrets |
| ingress.addReleaseNameAsHost | bool | `false` | dditional rules[].host |
| ingress.annotations | object | `{}` | defines the annotations for ingresses |
| ingress.enabled | bool | `false` | Specifies whether a Ingress should be created |
| ingress.ingressClassName | string | `nil` | defines the IngressClass to be used If not set, the default class will be used https://kubernetes.io/docs/concepts/services-networking/ingress/#default-ingress-class |
| ingress.subDomain | string | `"local"` | Ingress Sub domain name |
| nameOverride | string | `""` | String to partially override  name |
| serviceAccount.annotations | object | `{}` | defines the annotations to add to the service account |
| serviceAccount.create | bool | `false` | defines whether a service account should be created |
| serviceAccount.name | string | `""` | defines the name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| validator.affinity | object | `{}` | Affinity for validator pods assignment |
| validator.args | list | `[]` | Override default container args (useful when using custom images) |
| validator.command | list | `["cartesi-rollups-node"]` | Override default container command (useful when using custom images) |
| validator.config.CARTESI_AUTH_AWS_KMS_KEY_ID | string | `""` | If set, the node will use the AWS KMS service with this key ID to sign transactions.    Must be set alongside `CARTESI_AUTH_AWS_KMS_REGION`. |
| validator.config.CARTESI_AUTH_AWS_KMS_REGION | string | `""` | An AWS KMS Region.    Must be set alongside `CARTESI_AUTH_AWS_KMS_KEY_ID`. |
| validator.config.CARTESI_AUTH_MNEMONIC | string | `""` | The node will use the private key generated from this mnemonic to sign transactions.    Overrides `CARTESI_AUTH_MNEMONIC_FILE` and `CARTESI_AUTH_AWS_KMS_*`. |
| validator.config.CARTESI_AUTH_MNEMONIC_ACCOUNT_INDEX | string | `"0"` | When using mnemonics to sign transactions,   the node will use this account index to generate the private key. |
| validator.config.CARTESI_AUTH_MNEMONIC_FILE | string | `""` | The node will use the private key generated from the mnemonic contained in this file   to sign transactions.    Overrides `CARTESI_AUTH_AWS_KMS_*`. |
| validator.config.CARTESI_BLOCKCHAIN_BLOCK_TIMEOUT | string | `"60"` | Block subscription timeout in seconds. |
| validator.config.CARTESI_BLOCKCHAIN_FINALITY_OFFSET | string | `"10"` | The node assumes that blocks offseted by N from the current block have reached finality   (N is the read depth). |
| validator.config.CARTESI_BLOCKCHAIN_HTTP_ENDPOINT | string | `""` | HTTP endpoint for the blockchain RPC provider. |
| validator.config.CARTESI_BLOCKCHAIN_ID | string | `""` | An unique identifier representing a blockchain network. |
| validator.config.CARTESI_BLOCKCHAIN_IS_LEGACY | string | `"false"` | If set to true the node will send transactions using the legacy gas fee model   (instead of EIP-1559). |
| validator.config.CARTESI_BLOCKCHAIN_WS_ENDPOINT | string | `""` | WebSocket endpoint for the blockchain RPC provider. |
| validator.config.CARTESI_CONTRACTS_AUTHORITY_ADDRESS | string | `""` | Address of the Authority contract. |
| validator.config.CARTESI_CONTRACTS_DAPP_ADDRESS | string | `""` | Address of the DApp's contract. |
| validator.config.CARTESI_CONTRACTS_DAPP_DEPLOYMENT_BLOCK_NUMBER | string | `""` | Block in which the DApp's contract was deployed. |
| validator.config.CARTESI_CONTRACTS_HISTORY_ADDRESS | string | `""` | Address of the History contract. |
| validator.config.CARTESI_CONTRACTS_INPUT_BOX_ADDRESS | string | `""` | Address of the InputBox contract. |
| validator.config.CARTESI_CONTRACTS_INPUT_BOX_DEPLOYMENT_BLOCK_NUMBER | string | `""` | The deployment block for the input box contract.   The node will begin to read blockchain events from this block. |
| validator.config.CARTESI_EPOCH_DURATION | string | `"86400"` | Duration of a rollups epoch in seconds.    At the end of each epoch, the node will send claims to the blockchain. |
| validator.config.CARTESI_EXPERIMENTAL_SUNODO_VALIDATOR_ENABLED | string | `"false"` | When enabled, the node does not start the authority-claimer service and the Redis server. |
| validator.config.CARTESI_EXPERIMENTAL_SUNODO_VALIDATOR_REDIS_ENDPOINT | string | `""` | External Redis endpoint for the node when running in the experimental sunodo validator mode. |
| validator.config.CARTESI_FEATURE_DISABLE_MACHINE_HASH_CHECK | string | `"false"` | |   If set to true, the node will *not* check whether the Cartesi machine hash from   the snapshot matches the hash in the Application contract. |
| validator.config.CARTESI_FEATURE_HOST_MODE | string | `"false"` | If set to true, the node will run in host mode.    In host mode, computations will not be performed by the cartesi machine.   You should only use host mode for development and debugging! |
| validator.config.CARTESI_FEATURE_READER_MODE | string | `"false"` | If set to true, the node will run in reader mode.    In reader mode, the node does not make claims. |
| validator.config.CARTESI_HTTP_ADDRESS | string | `"127.0.0.1"` | HTTP address for the node. |
| validator.config.CARTESI_HTTP_PORT | string | `"10000"` | HTTP port for the node.   The node will also use the 20 ports after this one for internal services. |
| validator.config.CARTESI_LOG_LEVEL | string | `"info"` | One of "debug", "info", "warning", "error". |
| validator.config.CARTESI_LOG_TIMESTAMP | string | `"false"` | If set to true, the node will print the timestamp when logging. |
| validator.config.CARTESI_POSTGRES_ENDPOINT | string | `""` | Postgres endpoint in the 'postgres://user:password@hostname:port/database' format.    If not set, or set to empty string, will defer the behaviour to the PG driver.   See [this](https://www.postgresql.org/docs/current/libpq-envars.html) for more information.    It is also possible to set the endpoint without a password and load it from Postgres' passfile.   See [this](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNECT-PASSFILE)   for more information. |
| validator.config.CARTESI_SNAPSHOT_DIR | string | `""` | Path to the directory with the cartesi-machine snapshot that will be loaded by the node. |
| validator.extraArgs | list | `[]` | Extra arguments for dispatcher |
| validator.extraEnvVars | list | `[]` | Array with extra environment variables to add to validator.validator Pod # e.g: # extraEnvVars: #   - name: FOO #     value: "bar" # |
| validator.extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra env vars for validator Pod # |
| validator.extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra env vars for validator Pod # |
| validator.extraVolumeMounts | list | `[]` | Optionally specify extra list of additional volumeMounts for the validator Pod(s) |
| validator.extraVolumes | list | `[]` | Optionally specify extra list of additional volumes for the validator pod(s) |
| validator.healthCheck.enabled | bool | `true` | enable/disable health check for dispatcher |
| validator.healthCheck.port | int | `8081` | define the health check port for dispatcher |
| validator.image | object | `{"digest":null,"registry":null,"repository":"cartesi/rollups-node","tag":null}` | Set the dispatcher docker image |
| validator.initContainers | list | `[]` | add additional init containers to the dispatcher pod(s) # Example # # initContainers: #   - name: do-something #     image: busybox #     command: ['do', 'something'] # |
| validator.logLevel | string | `"info"` | The RUST_LOG level can be set to trace, debug, info, warn, error, or off. |
| validator.nodeSelector | object | `{}` | Node labels for validator pods assignment |
| validator.podAnnotations | object | `{}` | Annotations for Validator replicas pods |
| validator.podSecurityContext | object | `{}` | validator replicas pod's Security Context |
| validator.resources | object | `{}` | Set validator Pod resources |
| validator.securityContext | object | `{}` | Set validator Pod Security Context |
| validator.service.type | string | `"ClusterIP"` | validator service type |
| validator.tolerations | list | `[]` | Tolerations for validator pods assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-node \
  --set dapp.network=sepolia \
    oci://docker.io/cartesi/rollups-node-chart
```

The above command sets the network to sepolia `network`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-node -f values.yaml oci://docker.io/cartesi/rollups-node-chart
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### Rolling VS Immutable tags

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Cartesi will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting Pod's affinity

This chart allows you to set your custom affinity. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)