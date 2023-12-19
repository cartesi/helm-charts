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
      name: "{{ .Release.Name }}-sepolia-deployment"
    data:
      "sepolia.json": |
        {
          "contracts": {
            "Authority": { "address": "0x5827Ec9365D3a9b27bF1dB982d258Ad234D37242" },
            "History": { "address": "0x76f4dCaC0920826541EE718214EEE4be07346cEE" },
            "InputBox": { "address": "0x59b22D57D4f067708AB0c00552767405926dc768" }
          }
        }
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
      ROLLUPS_DEPLOYMENT_FILE: "/opt/cartesi/share/deployments/sepolia.json"
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-authority-claimer"
    data:
      RUST_LOG: "info"
      RD_EPOCH_DURATION: "86400"
      SC_GRPC_ENDPOINT: 'http://{{ include "validator.fullname" . }}-state-server:50051'
      TX_CHAIN_IS_LEGACY: "false"
      SC_DEFAULT_CONFIRMATIONS: "1"
      ROLLUPS_DEPLOYMENT_FILE: "/opt/cartesi/share/deployments/sepolia.json"
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-state-server"
    data:
      RUST_LOG: "info"
      SF_GENESIS_BLOCK: "3963384"
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

dispatcher:
  extraEnvVarsCM: "{{ .Release.Name }}-dispatcher"
  healthCheck:
    enabled: true
  extraVolumes:
    - name: sepolia-deployment
      configMap:
        name: "{{ .Release.Name }}-sepolia-deployment"
  extraVolumeMounts:
    - name: sepolia-deployment
      mountPath: /opt/cartesi/share/deployments
      readOnly: true
authorityClaimer:
  extraEnvVarsCM: "{{ .Release.Name }}-authority-claimer"
  extraVolumes:
    - name: sepolia-deployment
      configMap:
        name: "{{ .Release.Name }}-sepolia-deployment"
  extraVolumeMounts:
    - name: sepolia-deployment
      mountPath: /opt/cartesi/share/deployments
      readOnly: true
stateServer:
  extraEnvVarsCM: "{{ .Release.Name }}-state-server"
serverManager:
  advanceRunner:
    extraEnvVarsCM: "{{ .Release.Name }}-advance-runner"
inspectServer:
  extraEnvVarsCM: "{{ .Release.Name }}-inspect-server"

image:
  pullPolicy: Always

redis:
  enabled: false
  clusterEndpoints: redis://redis-master

postgresql:
  enabled: false
  endpoint:
    value: postgres://postgres:postgres@postgresql.default.svc.cluster.local:5432/postgres
