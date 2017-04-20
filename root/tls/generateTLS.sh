#!/usr/bin/env bash

# CN O
HOST=$1

# use current path as base path
BASE=$(cd `dirname $0`; pwd)/${HOST}
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

PEM_INCLUDESPRIVATEKEY_FILE=${BASE}/tls.includesprivatekey.pem
if [ ! -f "$PEM_INCLUDESPRIVATEKEY_FILE" ]; then
    touch ${PEM_INCLUDESPRIVATEKEY_FILE}
fi

PEM_PRIVATE_FILE=${BASE}/private.pem
PEM_PUBLIC_FILE=${BASE}/public.pem

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"

cat ${KEY_FILE}  | base64 | xargs echo -n | sed -e 's/[ ][ ]*//g' > ${KEY_BASE64}
cat ${CERT_FILE} | base64 | xargs echo -n | sed -e 's/[ ][ ]*//g' > ${CERT_BASE64}

cat ${CERT_FILE} ${KEY_FILE} > ${PEM_INCLUDESPRIVATEKEY_FILE}

openssl rsa -in ${KEY_FILE} -text > ${PEM_PRIVATE_FILE}
openssl x509 -inform PEM -in ${CERT_FILE} > ${PEM_PUBLIC_FILE}