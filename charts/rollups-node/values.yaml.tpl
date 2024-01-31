# (c) Cartesi and individual authors (see AUTHORS)
# SPDX-License-Identifier: Apache-2.0 (see LICENSE)

## dapp deployment paramaters
##
dapp:
  # -- the complete image name, e.g. "cartesi/dapp:echo-python-0.8.0-server"
  # (REQUIRED)
  image:
  # -- the name of the network the dapp is deployed on
  # (REQUIRED)
  # Available options are:
  #   - mainnet
  #   - optimism
  #   - optimism-goerli
  #   - arbitrum
  #   - arbitrum-goerli
  #   - localhost
  #   - sepolia
  network:

## cartesi holds the configuration for the default containers images
##
global:
  image:
    # -- Global Docker image registry
    registry: docker.io
    # -- Global Docker Image tag
    tag: 1.3.0

## seviceAccount configuration to be used by the rollups-validator-node
##
serviceAccount:
  # -- defines whether a service account should be created
  create: false
  # -- defines the annotations to add to the service account
  annotations: {}
  # -- defines the name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

# -- String to fully override name
fullnameOverride: ""
# -- String to partially override  name
nameOverride: ""

## image configuration to be used by the rollups-validator-node
##
image:
  # -- Pullpolicy for Docker Images
  pullPolicy: Always
  # -- Cartesi Rollups Validator Nodes pull secrets
  pullSecrets: []

## ingress defines whether an Ingress will be created for the dapp
## The default Ingress has a default path / that points to the endpoints.graphqlServer
## And an /inspect path that points to the endpoints.inspectServer
## The dapp.contractAddress is used a a hostname suffixed by the ingress.subDomain
## e.g.
## host: 0xabcde.local
##
ingress:
  # -- Specifies whether a Ingress should be created
  enabled: false
  # -- defines the IngressClass to be used
  # If not set, the default class will be used
  # https://kubernetes.io/docs/concepts/services-networking/ingress/#default-ingress-class
  ingressClassName:
  # -- Ingress Sub domain name
  subDomain: "local"
  ## ingress.addReleaseNameCNAME adds the helm release name to the ingress as an additional rules[].host: {}
  ## You should be careful to use a release name that's safe to use as a hostname
  ## e.g. "my-release-name"
  ## You shouldn't use "_" as a character in a hostname
  # -- dditional rules[].host
  addReleaseNameAsHost: false
  # -- defines the annotations for ingresses
  annotations: {}

## extraDeploy Extra objects to deploy (value evaluated as a template)
# -- Array of extra objects to deploy with the release
extraDeploy: []

validator:
  # -- Set the dispatcher docker image
  image:
    registry:
    repository: cartesi/rollups-node
    tag:
    digest:

  # -- Node labels for validator pods assignment
  nodeSelector: {}

  # -- Tolerations for validator pods assignment
  tolerations: []

  # -- Affinity for validator pods assignment
  affinity: {}

  # -- add additional init containers to the dispatcher pod(s)
  ## Example
  ##
  ## initContainers:
  ##   - name: do-something
  ##     image: busybox
  ##     command: ['do', 'something']
  ##
  initContainers: []

  # -- validator replicas pod's Security Context
  podSecurityContext:
    {}
    ## fsGroup: 2000

  # -- Annotations for Validator replicas pods
  podAnnotations: {}

  # -- Optionally specify extra list of additional volumes for the validator pod(s)
  extraVolumes: []

  # -- The RUST_LOG level can be set to trace, debug, info, warn, error, or off.
  logLevel: info

  healthCheck:
    # -- enable/disable health check for dispatcher
    enabled: true
    # -- define the health check port for dispatcher
    port: 8081

  # -- Override default container command (useful when using custom images)
  command: ["cartesi-rollups-node"]

  # -- Override default container args (useful when using custom images)
  args: []

  # -- Extra arguments for dispatcher
  extraArgs: []

  # -- Array with extra environment variables to add to validator.validator Pod
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []

  # -- Name of existing ConfigMap containing extra env vars for validator Pod
  ##
  extraEnvVarsCM: ""

  # -- Name of existing Secret containing extra env vars for validator Pod
  ##
  extraEnvVarsSecret: ""

  service:
    # -- validator service type
    type: ClusterIP

  # -- Set validator Pod Security Context
  securityContext:
    {}
    ## capabilities:
    ##   drop:
    ##   - ALL
    ## readOnlyRootFilesystem: true
    ## runAsNonRoot: true
    ## runAsUser: 1000

  # -- Set validator Pod resources
  resources:
    {}
    ## limits:
    ##   cpu: 100m
    ##   memory: 128Mi
    ## requests:
    ##   cpu: 100m
    ##   memory: 128Mi

  # -- Optionally specify extra list of additional volumeMounts for the validator Pod(s)
  extraVolumeMounts: []
