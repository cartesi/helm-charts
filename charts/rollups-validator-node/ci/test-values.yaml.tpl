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
  rollupsVersion: "0.4.0"

image:
  pullPolicy: Always
  pullSecrets:
    - name: regcred

validator:
  indexer:
    image:
      repository: cartesicorp/rollups-indexer
      tag: develop
  dispatcher:
    image:
      repository: cartesicorp/rollups-dispatcher
      tag: develop
    extraEnvVars:
      - name: MY_ENV_VAR
        value: "a-value"
  stateServer:
    image:
      repository: cartesicorp/rollups-state-server
      tag: develop

endpoints:
  inspectServer:
    image:
      repository: cartesicorp/rollups-inspect-server
      tag: develop

  queryServer:
    image:
      repository: cartesicorp/query-server
      tag: develop
