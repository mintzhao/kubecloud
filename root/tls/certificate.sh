#! /bin/bash
#
# using this script to generate certificate which signed by ca

# target host names, such as ssl.example.com, split up by `,`, must specified
TARGET_HOST=$1

# output location, must specified
OUTPUT_LOCATION=$2

# location of ca, default `~/.ca`
# this script will use ca.pem and ca-key.pem as ca file,
# if not specified, the script will generate a ca, and put them into the location
CA_LOCATION=$3

# ca profile, default `certificate`
CA_PROFILE=$4

# generate ca
generateca(){
  # generate ca-config
  cat >$CA_LOCATION/ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "certificate": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
EOF

  cat >$CA_LOCATION/ca-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "China",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

  cfssl gencert -initca $CA_LOCATION/ca-csr.json | cfssljson -bare $CA_LOCATION/ca
}

# check ca whether existed
checkca(){
  if [[ -z "$CA_LOCATION" ]]; then
    CA_LOCATION="~/.ca"
  fi

  if [[ ! -d "$CA_LOCATION" ]]; then
    mkdir -p $CA_LOCATION
  fi

  # no ca file, generate ca
  if [[ ! -f "$CA_LOCATION/ca.pem" ]]; then
    generateca
  fi

  if [[ -z "$CA_PROFILE" ]]; then
    CA_PROFILE="certificate"
  fi
}

#
# BEGIN SHELL
# check target
if [[ -z "$TARGET_HOST" ]]; then
  echo "`TARGET_HOST` not specified, exit"
  exit -1
fi

IFS=","
TARGET_HOST_ARRAY=($TARGET_HOST)
TARGET_HOSTS=""

for host in ${TARGET_HOST_ARRAY[@]}; do
  TARGET_HOSTS=${TARGET_HOSTS}'"'${host}'",'
done
TARGET_HOSTS_LEN=${#TARGET_HOSTS}-1
# TARGET_HOSTS=${TARGET_HOSTS:0:TARGET_HOSTS_LEN}
echo $TARGET_HOSTS

# check whether specified location of output
if [[ -z "$OUTPUT_LOCATION" ]]; then
  echo "`OUTPUT_LOCATION` not specified, exit"
  exit -1
fi
if [[ ! -d "$OUTPUT_LOCATION" ]]; then
  mkdir -p $OUTPUT_LOCATION
fi

# check ca
checkca

# generate cert-csr.json
cat >$OUTPUT_LOCATION/cert-csr.json <<EOF
{
    "CN": "kubernetes",
    "hosts": [
      "127.0.0.1",
      $TARGET_HOSTS
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "China",
            "ST": "Beijing",
            "L": "Beijing",
            "O": "system",
            "OU": "system"
        }
    ]
}
EOF

# generate target certificate
cfssl gencert -ca=$CA_LOCATION/ca.pem \
              -ca-key=$CA_LOCATION/ca-key.pem \
              -config=$CA_LOCATION/ca-config.json \
              -profile=$CA_PROFILE \
              $OUTPUT_LOCATION/cert-csr.json \
              | cfssljson -bare $OUTPUT_LOCATION/cert

# formate certificate file into base64
if [[ -f "$OUTPUT_LOCATION/cert-key.pem" ]]; then
  cat $OUTPUT_LOCATION/cert-key.pem | base64 | xargs echo -n | sed -e 's/[ ][ ]*//g' >$OUTPUT_LOCATION/cert-key.pem.base64
fi
if [[ -f "$OUTPUT_LOCATION/cert.pem" ]]; then
  cat $OUTPUT_LOCATION/cert.pem | base64 | xargs echo -n | sed -e 's/[ ][ ]*//g' >$OUTPUT_LOCATION/cert.pem.base64
fi

exit 0