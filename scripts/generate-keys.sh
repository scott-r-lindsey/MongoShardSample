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

cd $__root/keys

if [ -e $__root/keys/mongoCA.key ]; then
    green "-------------------------------------------------------------------------------"
    green " CA Key is present"
    green "-------------------------------------------------------------------------------"
    exit 0;
fi

green "-------------------------------------------------------------------------------"
green " Generating CA key "
green "-------------------------------------------------------------------------------"
# in a production environment the CA key should be centrally managed,
# not created ad-hoc!!!!
start_teal
openssl genrsa -out mongoCA.key -passout pass:NOTSECURE -aes256 8192
end_color


green "-------------------------------------------------------------------------------"
green " Generating CA certificate "
green "-------------------------------------------------------------------------------"
start_teal
openssl req -x509 -new -extensions v3_ca -key mongoCA.key -days 365 -out mongoCA.crt \
    -passin pass:NOTSECURE \
    -subj "/C=US/ST=Nowhere/L=Seattle/O=Test Only/OU=Scott Lindsey/CN=ssl.nonesuch.test"
end_color


for VAR in config alpha beta gamma
do
    for I in 1 2 3
    do
        HOST="$VAR-$I"
        SUBJECT="/C=US/ST=Nowhere/L=Seattle/O=OrganisationName/OU=TestMongoBuild/CN=$HOST"
        mkdir $HOST;

        green "-------------------------------------------------------------------------------"
        green " Generating CSR for $HOST"
        green "-------------------------------------------------------------------------------"

        start_teal
        openssl req -new -nodes -newkey rsa:4096 \
            -subj "$SUBJECT" \
            -keyout $HOST/key.key \
            -out $HOST/csr.csr
        end_color

        green "-------------------------------------------------------------------------------"
        green " Generating certificate for $HOST"
        green "-------------------------------------------------------------------------------"

        start_teal
        openssl x509 \
            -passin pass:NOTSECURE \
            -CA mongoCA.crt \
            -CAkey mongoCA.key \
            -CAcreateserial \
            -req -days 365 \
            -in $HOST/csr.csr \
            -out $HOST/crt.crt
        end_color

        cat $HOST/key.key $HOST/crt.crt >$HOST/secret.pem
        cp mongoCA.crt $HOST/

        mv $HOST $__root/volumes/$HOST/ssl
    done
done

### mongos by itself for now because I am only adding one to the cluster

HOST="mongos-1"
SUBJECT="/C=US/ST=Nowhere/L=Seattle/O=OrganisationName/OU=TestMongoBuild/CN=$HOST"
mkdir $HOST;

green "-------------------------------------------------------------------------------"
green " Generating CSR for $HOST"
green "-------------------------------------------------------------------------------"

start_teal
openssl req -new -nodes -newkey rsa:4096 \
    -subj "$SUBJECT" \
    -keyout $HOST/key.key \
    -out $HOST/csr.csr
end_color

green "-------------------------------------------------------------------------------"
green " Generating certificate for $HOST"
green "-------------------------------------------------------------------------------"

start_teal
openssl x509 \
    -passin pass:NOTSECURE \
    -CA mongoCA.crt \
    -CAkey mongoCA.key \
    -CAcreateserial \
    -req -days 365 \
    -in $HOST/csr.csr \
    -out $HOST/crt.crt
end_color

cat $HOST/key.key $HOST/crt.crt >$HOST/secret.pem
cp mongoCA.crt $HOST/

mv $HOST $__root/volumes/$HOST/ssl
