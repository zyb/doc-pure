#! /bin/bash

lan_mac="b8:88:e3:e6:1d:d3"
wlan_mac="08:3e:8e:a3:51:db"
phone_mac="38:BC:1A:CF:4E:56"

# param1
default_mac=""
set_mac="$phone_mac"
if [ "lan" == "$1" ]; then
	default_mac=$lan_mac
elif [ "wlan" == "$1" ]; then
	default_mac=$wlan_mac
else
	echo "first params must be ['lan' or 'wlan']"
	exit 1
fi

# param2
if [ "" != "$2" ]; then
	dvc_id="$2"
	echo "device id: $dvc_id"
else
	echo "second params is device id, must not be empty, such as ['enp12s0' or 'wlp3s0b1']"
	exit 1
fi

# param3
if [ "" == "$3" ]; then
	mac=$default_mac
	echo "reset to default: $mac"
else
	mac=$set_mac
	echo "set mac: $set_mac"
fi

systemctl stop NetworkManager
ip link set $dvc_id down
ip link set $dvc_id address $mac
ip link set $dvc_id up
systemctl start NetworkManager
