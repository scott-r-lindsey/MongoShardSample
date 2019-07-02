# Mongo Shard Sample

This is an example mongodb cluster created locally via docker-compose.  This is an experiment and a playground --
this is not a sensible way to run a cluster of MongoDB servers.

## Requirements

This will run on Linux machines with ```docker```, ```docker-compose``` and ```openssl``` installed, and perhaps also on
other platforms (not currently tested).

## Setup

After checking out the repository, copy config.sh.dist to config.sh, and edit this file.
You may change any value -- in particular the port numbers may be worth changing if the 
ports listed are already in use on your system.

To bring up the cluster, run ./scripts/start.sh.
```bash
cd MongoShardSample
./scripts/start.sh
```
SSL keys will be generated on the first execution of start.sh.  Next, run each of the 
following commands to complete initialization of the cluster:
```bash
./scripts/01-configure-config-servers.sh
./scripts/02-configure-alpha-shard.sh
./scripts/03-configure-beta-shard.sh
./scripts/04-configure-gamma-shard.sh
./scripts/05-add-users.sh
./scripts/06-configure-mongos.sh
./scripts/07-create-sharded-database.sh
```

## Use

You may validate the status of each replication set with the following commands

```bash
./scripts/get-alpha-replication-status.sh
./scripts/get-beta-replication-status.sh
./scripts/get-config-replication-status.sh
./scripts/get-gamma-replication-status.sh
./scripts/get-mongos-status.sh
```

To shell into the mongos instance, run
```bash
./scripts/sh-mongos-1
```
And you may use MongoAdmin at http://localhost:1234 after having run the setup scripts.

## Thanks

I could not have done this without the many guides already put together by members of the MongoDB community.  These links include:

    * https://medium.com/@rossbulat/deploy-a-3-node-mongodb-3-6-replica-set-with-x-509-authentication-self-signed-certificates-d539fda94db4
    * https://hackernoon.com/create-a-mongodb-sharded-cluster-with-ssl-enabled-dace56bc7a17

