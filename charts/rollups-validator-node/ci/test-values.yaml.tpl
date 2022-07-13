dapp:
  image: cartesi/dapp:echo-python-0.7.0-server
  contractAddress: "0x5a4ac602d25e86b853cdd07836445f576382f4db"
  mnemonic: "${MNEMONIC}"
  httpProvider: https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  wsProvider: wss://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_API_KEY}
  network: polygon_mumbai
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

queryServer:
  image:
    repository: cartesicorp/query-server
    tag: develop
