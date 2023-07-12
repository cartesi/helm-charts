dapp:
  image: docker.io/cartesi/dapp:echo-python-0.15.0-server
  contractAddress: 0x4c680fe34207A852218160de6c37804863880f2c
  blockHash: "0x3aaf0bf5152d7f43f944134aee081acb4179997aef104d602bef4b36c1269d17"
  blockNumber: "9251165"
  transactionHash: "0x4c1ba6ebb641c542b459a1258fac921487873c6ded70794090829ab52dcb32dc"
  mnemonic:
    value: "${MNEMONIC}"
  httpProvider: https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  wsProvider: wss://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  network: goerli

cartesi:
  rollupsVersion: "0.9.1"

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
      SERVER_MANAGER_ADDRESS: '{{ include "validator.fullname" . }}-server-manager:5001'

validator:
  localnode:
    enabled: true
    anvil:
      image:
        registry: sunodo
        repository: anvil
        tag: 2.0.0
      anvilState:
        image:
          registry: sunodo
          repository: rollups-node
          tag: 0.2.0
    deployer:
      image:
        registry: cartesi
        repository: rollups-cli
        tag: 0.9.1
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
  endpoint: redis://redis-master

postgresql:
  enabled: false
