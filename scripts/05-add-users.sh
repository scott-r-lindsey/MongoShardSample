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
green " Adding admin user"
green "-------------------------------------------------------------------------------"

start_teal
docker exec -i mongo-shard-router-1 mongo --port 27017 << EOM
db.getSiblingDB("admin").createUser(
  {
    user: "${ADMIN_USER}",
    pwd: "${ADMIN_PASSWORD}",
    roles: [
      { role: "root", db: "admin" },
    ],
    writeConcern: { w: "majority" , wtimeout: 5000 }
  }
)

db.getSiblingDB("admin").auth("${ADMIN_USER}", "${ADMIN_PASSWORD}");

db.getSiblingDB("${APP_DATABASE}").createUser(
  {
    user: "${ADMIN_USER}",
    pwd: "${ADMIN_PASSWORD}",
    roles: [
      { role: "dbOwner", db: "admin" },
      { role: "clusterMonitor", db:"admin"}

    ],
    writeConcern: { w: "majority" , wtimeout: 5000 }
  }
)

EOM
end_color

green "-------------------------------------------------------------------------------"
green " Adding application user"
green "-------------------------------------------------------------------------------"

start_teal
docker exec -i mongo-shard-router-1 mongo --port 27017 << EOM
db.getSiblingDB("admin").auth("${ADMIN_USER}", "${ADMIN_PASSWORD}");
db.getSiblingDB("${APP_DATABASE}").createUser(
  {
    user: "${APP_USER}",
    pwd: "${APP_PASSWORD}",
    roles: [
      { role: "dbOwner", db: "${APP_DATABASE}" },
    ],
    writeConcern: { w: "majority" , wtimeout: 5000 }
  }
)
EOM
end_color


green "-------------------------------------------------------------------------------"
green " Done."
green "-------------------------------------------------------------------------------"
