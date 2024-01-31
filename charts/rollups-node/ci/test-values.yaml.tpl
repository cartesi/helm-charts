validator:
  application:
    image: cartesi/dapp:echo-python-0.16.0-server
  healthCheck:
    enabled: true
  config:
    CARTESI_LOG_LEVEL: "info"
    CARTESI_HTTP_ADDRESS: "0.0.0.0"
    CARTESI_HTTP_PORT: "10000"
    CARTESI_POSTGRES_ENDPOINT: "postgres://postgres:postgres@postgresql.default.svc.cluster.local:5432/postgres"
    CARTESI_BLOCKCHAIN_ID: "11155111"
    CARTESI_BLOCKCHAIN_HTTP_ENDPOINT: "https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}"
    CARTESI_BLOCKCHAIN_WS_ENDPOINT: "wss://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}"
    CARTESI_BLOCKCHAIN_IS_LEGACY: "false"
    CARTESI_BLOCKCHAIN_FINALITY_OFFSET: "1"
    CARTESI_CONTRACTS_APPLICATION_ADDRESS: "0x9f12D4365806FC000D6555ACB85c5371b464E506"
    CARTESI_CONTRACTS_APPLICATION_DEPLOYMENT_BLOCK_NUMBER: "4152308"
    CARTESI_CONTRACTS_HISTORY_ADDRESS: "0x76f4dCaC0920826541EE718214EEE4be07346cEE"
    CARTESI_CONTRACTS_AUTHORITY_ADDRESS: "0x5827Ec9365D3a9b27bF1dB982d258Ad234D37242"
    CARTESI_CONTRACTS_INPUT_BOX_ADDRESS: "0x59b22D57D4f067708AB0c00552767405926dc768"
    CARTESI_CONTRACTS_INPUT_BOX_DEPLOYMENT_BLOCK_NUMBER: "3963384"
    CARTESI_EPOCH_DURATION: "86400"
    CARTESI_FEATURE_READER_MODE: "true"
    CARTESI_FEATURE_DISABLE_MACHINE_HASH_CHECK: "true"
    CARTESI_SNAPSHOT_DIR: "/usr/share/cartesi/snapshot"
    CARTESI_AUTH_MNEMONIC: "${MNEMONIC}"
  initContainers:
    - image: "{{ .Values.validator.application.image }}"
      name: snapshot-provisioner
      command:
        - cp
        - -rv
        - /var/opt/cartesi/machine-snapshots/0_0/.
        - /destination/machine-snapshots/
      volumeMounts:
        - name: snapshots
          mountPath: /destination/machine-snapshots
          readOnly: false
  extraVolumes:
    - name: snapshots
      emptyDir: {}
  extraVolumeMounts:
    - name: snapshots
      mountPath: /usr/share/cartesi/snapshot
      readOnly: false

image:
  pullPolicy: Always
