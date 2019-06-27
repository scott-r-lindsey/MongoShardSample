#!/usr/bin/env bash

#------------------------------------------------------------------------------
set -o pipefail
set -e
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
__here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$__here/../"


. $__here/lib/colors.sh
. $__root/config.sh

#------------------------------------------------------------------------------

green "-------------------------------------------------------------------------------"
green " Adding alpha shard to mongos... "
green "-------------------------------------------------------------------------------"
red "> sh.addShard( ... )"

# dramatic pause
sleep 1

start_teal
docker exec -i mongo-shard-router-1 mongo --port 27017 << EOM
    sh.addShard("alphaReplicationSet/alpha-shard-1:27018");
EOM

green "-------------------------------------------------------------------------------"
green " Adding beta shard to mongos... "
green "-------------------------------------------------------------------------------"
red "> sh.addShard( ... )"

# dramatic pause
sleep 1

start_teal
docker exec -i mongo-shard-router-1 mongo --port 27017 << EOM
    sh.addShard("betaReplicationSet/beta-shard-1:27018");
EOM

green "-------------------------------------------------------------------------------"
green " Adding gamma shard to mongos... "
green "-------------------------------------------------------------------------------"
red "> sh.addShard( ... )"

# dramatic pause
sleep 1

start_teal
docker exec -i mongo-shard-router-1 mongo --port 27017 << EOM
    sh.addShard("gammaReplicationSet/gamma-shard-1:27018");
EOM



green "-------------------------------------------------------------------------------"
green " Done."
green "-------------------------------------------------------------------------------"
