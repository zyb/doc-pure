#! /bin/bash

ssconf=$(curl "https://api.mianvpn.com/ajax.php?verify=true&mod=getfreess")
echo $ssconf | python -m json.tool
exit

pid=$(ps aux | grep "sslocal -s" | grep -v grep | tail -n 1 | awk '{print $2}')
if [[ "" != "$pid" ]]; then
	echo "sslocal already run: $pid, kill it."
	kill $pid
	sleep 0.5
fi

nmap 127.0.0.1 -p 12250 | grep open
port_exist=$(echo $?)
if [ "0" == "$port_exist" ]; then
	echo "sslocal port already used."
	exit
fi

num=2
ip=$(echo $ssconf | jq ".[$num].i" | sed 's/"//g')
port=$(echo $ssconf | jq ".[$num].p" | sed 's/"//g')
pw=$(echo $ssconf | jq ".[$num].pw" | sed 's/"//g')
md=$(echo $ssconf | jq ".[$num].m" | sed 's/"//g')

if [ ! -d /tmp/sstmp ]; then
	mkdir /tmp/sstmp
fi
tmpfile=$(mktemp /tmp/sstmp/sslog.XXXXXXXXXXXXX)
setsid sslocal -s $ip -p $port -k $pw -m $md -b 127.0.0.1 -l 12250 -v > $tmpfile 2>&1 &
sleep 0.5
exec_pid=$(ps aux | grep sslocal | grep -v grep | awk '{print $2}')
ps aux | grep sslocal
echo "sslocal start: $exec_pid, log: $tmpfile"
