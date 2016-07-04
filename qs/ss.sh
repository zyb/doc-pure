#! /bin/bash

curr=$(dirname $_)

exec_pid=$(ps aux | grep sslocal | grep -v grep | awk '{print $2}')
exec_qt5=$(pidof ss-qt5)

if [[ "" = "$exec_pid" && "" = "$exec_qt5" ]]; then
	if [ ! -d /tmp/sstmp ]; then
		mkdir /tmp/sstmp
	fi
	tmpfile=$(mktemp /tmp/sstmp/sslog.XXXXXXXXXXXXX)
	setsid sslocal -c $curr/ss/ss.conf > $tmpfile 2>&1 &
	sleep 0.5
	exec_pid=$(ps aux | grep sslocal | grep -v grep | awk '{print $2}')
	echo "sslocal start: $exec_pid, log: $tmpfile"
else
	echo "already run. sslocal: $exec_pid, ss-qt5: $exec_qt5"
fi
