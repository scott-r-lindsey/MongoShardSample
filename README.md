### Mongo Shard Sample

This is an example mongodb cluster created locally via docker-compose.  This is an experiment and a playground -- 
this is not a sensible way to run a cluster of MongoDB servers.

This will run on Linux machines with ```docker``` and ```docker-compose``` installed, and perhaps not other platforms
(not currently tested).

After checking out the repository, run the start.sh command to bring up the cluster:
```bash
./start.sh
```
Then, run each of the following to initiate replication and add each shard to the cluster:
```bash
./scripts/start-config-replication.sh
./scripts/start-alpha-replication.sh
./scripts/start-beta-replication.sh
./scripts/start-gamma-replication.sh
./scripts/add-shards-to-mongos.sh
```
You may validate the status of each replication set with the following commands

```bash
get-alpha-replication-status.sh
get-beta-replication-status.sh
get-config-replication-status.sh
get-gamma-replication-status.sh
get-mongos-status.sh
```
