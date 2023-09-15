dapp:
  image: "docker.io/cartesi/dapp:echo-python-0.16.0-server"
  contractAddress: "0x9f12D4365806FC000D6555ACB85c5371b464E506"
  blockHash: "0xd8c31e223c9790594594166abe91a71dee250586df6b93e2fd9079a5397f572c"
  blockNumber: "4152308"
  transactionHash: "0x3beea324c1db8a69829df784ed6af9edccc8f506777693e5124120535a27ab8b"
  mnemonic:
    value: "${MNEMONIC}"
  httpProvider: https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  wsProvider: wss://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  network: sepolia

extraDeploy:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-database"
    data:
      POSTGRES_HOSTNAME: "postgresql.default.svc.cluster.local"
      POSTGRES_PORT: "5432"
      POSTGRES_USER: "postgres"
      POSTGRES_DB: "postgres"
      POSTGRES_PASSWORD: "postgres"
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-dispatcher"
    data:
      RUST_LOG: "info"
      RD_EPOCH_DURATION: "86400"
      SC_GRPC_ENDPOINT: "http://localhost:50051"
      SC_DEFAULT_CONFIRMATIONS: "1"
      TX_CHAIN_IS_LEGACY: "false"
      TX_DEFAULT_CONFIRMATIONS: "2"
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-state-server"
    data:
      RUST_LOG: "info"
      SF_GENESIS_BLOCK: "0x1"
      SF_SAFETY_MARGIN: "1"
      BH_BLOCK_TIMEOUT: "8"
      SS_SERVER_ADDRESS: "0.0.0.0:50051"
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-advance-runner"
    data:
      SESSION_ID: "default_rollups_id"
      SERVER_MANAGER_ENDPOINT: "http://localhost:5001"
      SNAPSHOT_DIR: "/var/opt/cartesi/machine-snapshots"
      SNAPSHOT_LATEST: "/var/opt/cartesi/machine-snapshots/latest"
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-inspect-server"
    data:
      SESSION_ID: "default_rollups_id"
      INSPECT_SERVER_ADDRESS: "0.0.0.0:5005"

validator:
  localnode:
    enabled: false
dispatcher:
  extraEnvVarsCM: "{{ .Release.Name }}-dispatcher"
  healthCheck:
    enabled: true
stateServer:
  extraEnvVarsCM: "{{ .Release.Name }}-state-server"
indexer:
  extraEnvVarsCM: "{{ .Release.Name }}-database"
serverManager:
  advanceRunner:
    extraEnvVarsCM: "{{ .Release.Name }}-advance-runner"
endpoints:
  inspectServer:
    extraEnvVarsCM: "{{ .Release.Name }}-inspect-server"
  graphqlServer:
    extraEnvVarsCM: "{{ .Release.Name }}-database"

image:
  pullPolicy: Always

redis:
  enabled: false
  clusterEndpoints: redis://redis-master

postgresql:
  enabled: false
