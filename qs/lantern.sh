#! /bin/bash

if [ "" = "$1" ]; then
	default="/home/zyb/data/github/lantern/lantern_linux_amd64"
	lpath="$default"
else
	lpath="$1"
fi

exec_pid=$(pidof $lpath)
if [ "" = "$exec_pid" ]; then
	setsid $lpath --addr 0.0.0.0:12258 > /dev/null 2>&1 &
	sleep 0.5
	exec_pid=$(pidof $lpath)
	echo "start : $exec_pid [$lpath]"
else
	echo "'$lpath' already run: $exec_pid"
fi
