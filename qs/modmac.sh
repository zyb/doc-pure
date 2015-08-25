#! /bin/bash

if [ "" == "$1" ]; then
	mac="38:BC:1A:CF:4E:56"
elif [ "reset" == "$1" ]; then
	mac="b8:88:e3:e6:1d:d3"
fi

systemctl stop NetworkManager
ip link set enp12s0 down
ip link set enp12s0 address $mac
ip link set enp12s0 up
systemctl start NetworkManager
