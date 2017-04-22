#! /usr/bin/bash

sudo apt-get update
sudo apt-get install python-pip
pip install shadowsocks

mkdir /root/shadowsocks
touch /root/shadowsocks/shadowsocks.json

ssserver -c /root/shadowsocks/shadowsocks.json -d start