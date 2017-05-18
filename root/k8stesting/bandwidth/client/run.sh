#! /bin/bash
###############################################################################
# version 0.1:
#!use netperf test Bandwidth
###############################################################################
# vars
PACKET_SIZE_LIST="64 256 1024 4096 32768"
THREAD_NUM_LIST="1 2 4 8 16 32"
TEST_LEN=30
start_client(){
	result=$(iperf -c $SERVER -t $TEST_LEN -P $1|tac|sed -n 1p)
	bandwidth=$(echo $result | sed 's/.*MBytes\s\+\([0-9\.]\+\)\sMbits\/sec/\1/g')
    echo "[Result] thread num=$1, bandwidth=$bandwidth"
}
for thread_num in $THREAD_NUM_LIST
do
    start_client $thread_num
done