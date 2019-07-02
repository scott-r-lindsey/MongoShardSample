#!/bin/sh

mongod \
    --configsvr \
    --auth \
    --sslMode preferSSL \
    --sslPEMKeyFile /data/ssl/secret.pem \
    --sslCAFile /data/ssl/mongoCA.crt \
    --sslClusterFile /data/ssl/secret.pem \
    --sslPEMKeyPassword ${SSL_PEM_PASSWORD} \
    --sslClusterPassword ${SSL_PEM_PASSWORD} \
    --clusterAuthMode x509 \
    --replSet configReplicationSet \
    --bind_ip 0.0.0.0

