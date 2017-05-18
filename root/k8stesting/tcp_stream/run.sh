#! /bin/bash

# run test
netperf -t TCP_STREAM -H $SERVER -- -m 1024

# waitting 
/usr/sbin/sshd -D