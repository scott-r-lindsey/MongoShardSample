#!/usr/bin/env bash

#------------------------------------------------------------------------------
set -o pipefail
set -e
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
__here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$__here/../"


. $__here/lib/colors.sh

#------------------------------------------------------------------------------

green "-------------------------------------------------------------------------------"
green " Initializing configuration replica set..."
green "-------------------------------------------------------------------------------"
red "> rs.initiate( rsconf )"

# dramatic pause
sleep 1

start_teal
docker exec -i mongo-cluster-config1-container mongo --port 27019 << EOM
    rsconf = {
      _id: "configReplicationSet",
      members: [
        {
         _id: 0,
         host: "config-1:27019"
        },
        {
         _id: 1,
         host: "config-2:27019"
        },
        {
         _id: 2,
         host: "config-3:27019"
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
docker exec -i mongo-cluster-config1-container mongo --port 27019 --eval "rs.conf()"
end_color

green "-------------------------------------------------------------------------------"
green " Done."
green "-------------------------------------------------------------------------------"
