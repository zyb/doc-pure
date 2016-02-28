#! /bin/bash

if [ "$1" == "" ]; then
	echo "need params."
	exit 1
fi

# root@172.16.95.175

user=binzhang3
ip=172.16.59.13
port=21722

sshcmd="ssh $user@$ip -p $port"
sshcmd="$sshcmd $1"
`$sshcmd`

file=/home/$user/$2
if [ "$2" != "" ]; then
	scp -r -P $port $user@$ip:$file ./
	ssh $user@$ip -p $port "rm -r $file"
fi
