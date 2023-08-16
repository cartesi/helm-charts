# Cartesi Rollups Operator

The Cartesi Rollups Operator is a component responsible for launching Cartesi Rollups nodes on a Kubernetes cluster for applications created through the Cartesi Rollups Application CRD.

The Application CRD looks like the following:

```yaml
apiVersion: rollups.cartesi.io/v1
kind: DApp
metadata:
    name: dapp-3694c82f
spec:
    address: "0x3694c82fde031b8462e90E8Bfee0377De2B01ECc"
    blockHash: "0x7afe732e7bd035923c48f60991d019c588496a83b8f7082a5ae5502910395ff0"
    blockNumber: "10"
    cid: bafybeibdpcfqtcqhgjzmo5wzi3kraxdu6f4wm2hzna4tj2enkepzvldjtq
    transactionHash: "0x13c75f9871d0ae6dd2337bc9ae89fad1d16f6b1bd20ca5ccb950aadd5a7232e7"
```

The operator watches those resources changes and creates (or destroys) Kubernetes resources to run a node for that particular application.

## Cluster Setup

The Cartesi rollups nodes need some basic infrastructure that is shared between applications:

-   A [postgres](https://www.postgresql.org) database instance
-   A [redis](https://redis.com) instance
-   A Web3 Gateway ([Infura](https://www.infura.io), [Alchemy](http://alchemy.com), [Chainstack](http://chainstack.com), or any other)
-   An Ethereum wallet

### Postgres

Any postgres database provider can be used for Cartesi rollups nodes. If the cloud provider used by validator already provides a managed database system, like [AWS RDS](https://aws.amazon.com/en/rds/) or [Azure Database for PostgreSQL](https://azure.microsoft.com/en-us/products/postgresql), it works just fine.

The only requirement is that the operator needs credentials with permissions to create new databases on demand, because each application uses its own database.

If no managed database is available, another option is to deploy a postgres instance on the cluster using [Helm](https://helm.sh).

```shell
$ helm install postgres oci://registry-1.docker.io/bitnamicharts/postgresql
postgres-postgresql.default.svc.cluster.local
$ export POSTGRES_PASSWORD=$(kubectl get secret --namespace default postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
```

### Redis

```shell
$ helm install redis bitnami/redis --wait --set auth.enabled=false --set architecture=standalone --set image.tag=6.2-debian-11
redis-master.default.svc.cluster.local
```

### Wallet

```shell
kubectl create secret generic mnemonic --from-literal=MNEMONIC="test test test test test test test test test test test junk"
```

### Web3 Gateway

## Configuration

## Development
