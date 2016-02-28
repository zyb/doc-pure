#! /bin/bash

#ip link set wlp3s0b1 down
#ip link set enp12s0 up
#dhcpcd enp12s0

ps aux | grep AuthenMngService | grep -v grep | awk '{print $2}' | xargs kill -9
ps aux | grep iNodeMon | grep -v grep | awk '{print $2}' | xargs kill -9

/home/zyb/software/iNodeClient/AuthenMngService &
sleep 2
/home/zyb/software/iNodeClient/iNodeMon &
sleep 1
/home/zyb/software/iNodeClient/iNodeClient.sh &

