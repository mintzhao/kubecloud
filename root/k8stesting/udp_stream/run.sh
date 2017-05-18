#! /bin/bash

# run test
netperf -t UDP_STREAM -H $SERVER -- -m 1024

# waitting 
/usr/sbin/sshd -D