dapp:
  image: cartesi/dapp:echo-python-0.11.1-server
  contractAddress: "0xFbEfE8696D9631a78670E2541B33E5B2877a901F"
  mnemonic:
    value: "${MNEMONIC}"
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
  rollupsVersion: "0.8.2"

image:
  pullPolicy: Always

redis:
  enabled: false
  endpoint: redis://redis-master
