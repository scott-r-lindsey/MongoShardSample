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
green " Initializing gamma shard replica set..."
green "-------------------------------------------------------------------------------"
red "> rs.initiate( rsconf )"

# dramatic pause
sleep 1

start_teal
docker exec -i mongo-cluster-gamma1-container mongo --port 27018 << EOM
    rsconf = {
      _id: "gammaReplicationSet",
      members: [
        {
         _id: 0,
         host: "gamma-1:27018"
        },
        {
         _id: 1,
         host: "gamma-2:27018"
        },
        {
         _id: 2,
         host: "gamma-3:27018"
        }
       ]
    }

    rs.initiate( rsconf )
EOM

end_color
green "-------------------------------------------------------------------------------"
green " Validiation with rs.conf()"
green "-------------------------------------------------------------------------------"

red "> rs.conf()"

# dramatic pause
sleep 1

start_teal
docker exec -i mongo-cluster-gamma1-container mongo \
    --port 27018 \
    --ssl \
    --sslAllowInvalidHostnames \
    --sslPEMKeyFile /data/ssl/secret.pem \
    --sslCAFile /data/ssl/mongoCA.crt \
    --authenticationMechanism=MONGODB-X509 \
    --authenticationDatabase='$external' \
    --eval "rs.conf()"
end_color

green "-------------------------------------------------------------------------------"
green " Done."
green "-------------------------------------------------------------------------------"
