#!/usr/bin/env bash

# CN O
HOST=$1

# use current path as base path
BASE=$(cd `dirname $0`; pwd)/tls
if [ ! -d "$BASE" ]; then
    mkdir -p ${BASE}
fi

KEY_FILE=${BASE}/tls.key
KEY_BASE64=${BASE}/tlskey.base64
if [ ! -f "$KEY_BASE64" ]; then
    touch ${KEY_BASE64}
fi

CERT_FILE=${BASE}/tls.crt
CERT_BASE64=${BASE}/tlscrt.base64
if [ ! -f "$CERT_BASE64" ]; then
    touch ${CERT_BASE64}
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"

cat ${KEY_FILE} | base64 > ${KEY_BASE64}
cat ${CERT_FILE} | base64 > ${CERT_BASE64}