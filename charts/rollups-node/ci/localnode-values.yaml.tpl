dapp:
  image: docker.io/cartesi/dapp:echo-python-0.16.0-server

extraDeploy:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: "{{ .Release.Namespace }}"
      name: "{{ .Release.Name }}-dispatcher"
    data:
      RUST_LOG: "info"
      RD_EPOCH_DURATION: "86400"
      SC_GRPC_ENDPOINT: 'http://{{ include "validator.fullname" . }}-state-server:50051'
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
      SF_GENESIS_BLOCK: "1"
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

localnode:
  enabled: true
dispatcher:
  extraEnvVarsCM: "{{ .Release.Name }}-dispatcher"
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
  enabled: true
  architecture: standalone

postgresql:
  enabled: true
