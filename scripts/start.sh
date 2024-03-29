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

$__root/scripts/generate-keys.sh

teal "-------------------------------------------------------------------------------"
teal "> docker-compose up "
teal "-------------------------------------------------------------------------------"

cd $__root && docker-compose up


