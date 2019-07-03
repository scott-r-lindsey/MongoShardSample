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
green " Running db.democollection.getShardDistribution()"
green "-------------------------------------------------------------------------------"

red "> db.democollection.getShardDistribution()"

# dramatic pause
sleep 1

start_teal
docker exec -i mongo-shard-router-1 mongo --port 27017 << EOM
db.getSiblingDB("admin").auth("${ADMIN_USER}", "${ADMIN_PASSWORD}");
use ${APP_DATABASE};
db.democollection.getShardDistribution();
EOM
end_color

green "-------------------------------------------------------------------------------"
green " Done."
green "-------------------------------------------------------------------------------"
