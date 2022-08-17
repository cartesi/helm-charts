dapp:
  image: cartesi/dapp:echo-python-0.8.0-server
  contractAddress: "0xaf500c1c68d412b6fd18edc190f45b98604e0697"
  mnemonic: "${MNEMONIC}"
  httpProvider: https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  wsProvider: wss://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  network: goerli
  postgres:
    hostname: postgresql
    port: "5432"
    user: postgres
    password: postgres
    db: postgres

cartesi:
  rollupsVersion: "0.5.0"

image:
  pullPolicy: Always
  pullSecrets:
    - name: regcred

validator:
  indexer:
    image:
      repository: cartesi/rollups-indexer
      tag: 0.5.0
  dispatcher:
    image:
      repository: cartesi/rollups-dispatcher
      tag: 0.5.0
    extraEnvVars:
      - name: MY_ENV_VAR
        value: "a-value"
  stateServer:
    image:
      repository: cartesi/rollups-state-server
      tag: 0.5.0

endpoints:
  inspectServer:
    image:
      repository: cartesi/rollups-inspect-server
      tag: 0.5.0

  queryServer:
    image:
      repository: cartesi/query-server
      tag: 0.5.0
