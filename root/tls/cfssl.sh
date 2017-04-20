#! /usr/bin/bash

wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
chmod +x cfssl_linux-amd64
sudo mv cfssl_linux-amd64 /root/local/bin/cfssl

wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssljson_linux-amd64
sudo mv cfssljson_linux-amd64 /root/local/bin/cfssljson

wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x cfssl-certinfo_linux-amd64
sudo mv cfssl-certinfo_linux-amd64 /root/local/bin/cfssl-certinfo

$export PATH=/root/local/bin:$PATH

# CA
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

# image.example.com
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubecloud image-csr.json | cfssljson -bare image