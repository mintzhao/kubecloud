#! /bin/bash

# run test
netperf -t TCP_RR -H $SERVER

# waitting 
/usr/sbin/sshd -D