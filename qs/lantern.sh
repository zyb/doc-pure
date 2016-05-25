#! /bin/bash

if [ "" = "$1" ]; then
	default="/home/zyb/d/github/lantern/lantern"
	lpath="$default"
else
	lpath="$1"
fi

exec_pid=$(pidof $lpath)
if [ "" = "$exec_pid" ]; then
	setsid $lpath > /dev/null 2>&1 &
	sleep 0.5
	exec_pid=$(pidof $lpath)
	echo "start : $exec_pid [$lpath]"
else
	echo "'$lpath' already run: $exec_pid"
fi
