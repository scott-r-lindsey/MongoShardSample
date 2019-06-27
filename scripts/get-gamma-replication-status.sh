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
green " Running rs.conf() on mongo-cluster-gamma1-container"
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
