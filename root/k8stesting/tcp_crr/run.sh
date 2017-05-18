#! /bin/bash

# run test
netperf -t TCP_CRR -H $SERVER

# waitting 
/usr/sbin/sshd -D