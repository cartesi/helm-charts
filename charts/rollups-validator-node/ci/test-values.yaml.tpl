dapp:
  image: cartesi/dapp:echo-python-0.11.1-server
  contractAddress: "0xFbEfE8696D9631a78670E2541B33E5B2877a901F"
  blockHash: "0xe0419742fce673e894839c4373fe939a6c6999b0789a383887a029495a68f8ad"
  blockNumber: "8091770"
  transactionHash: "0x1c409e05e4025ffd239d219af5dc9b45d713955ed6c1e001328df9057c6902b1"

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
