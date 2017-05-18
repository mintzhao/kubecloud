#! /bin/bash

# run test
netperf -t UDP_RR -H $SERVER

# waitting 
/usr/sbin/sshd -D