#! /bin/bash
###############################################################################
# version 0.1:
#!use netperf test Bandwidth
###############################################################################
# vars
SERVER=$2
CLIENT=$1
PACKET_SIZE_LIST="64 256 1024 4096 32768"
THREAD_NUM_LIST="1 2 4 8 16 32"
TEST_LEN=30
start_server(){
    ssh $SERVER "sudo iperf -s -D"
    echo "[Success] Start iperf server@$SERVER."
}
stop_server(){
    ssh $SERVER "ps -ef|grep iperf|grep -v grep|awk '{print \$2}'|sudo xargs kill"
    echo "[Success] Stop iperf server@$SERVER."
}
start_client(){
    cmd="iperf -c $SERVER -t $TEST_LEN -P $1|tac|sed -n 1p"
    echo "Start iperf@$CLIENT, cmd:\n$cmd"
    result=$(ssh $CLIENT $cmd)
    bandwidth=$(echo $result|sed 's/.*MBytes\s\+\([0-9\.]\+\)\sMbits\/sec/\1/g')
    echo "[Result] thread num=$1, bandwidth=$bandwidth"
    echo "[Success] netperf test."
}
#start_server
for thread_num in $THREAD_NUM_LIST
do
    start_client $thread_num
done
#stop_server