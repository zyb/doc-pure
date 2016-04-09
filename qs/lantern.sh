#! /bin/bash

if [ "" = "$1" ]; then
	echo "need lantern path"
	exit 1
else
	if [ "d" = "$1" ]; then
		default="/home/zyb/d/github/lantern/lantern_linux_amd64"
		lpath="$default"
	else
		lpath="$1"
	fi
fi

exec_name="lantern_linux_amd64"
exec_pid=$(pidof $exec_name)
if [ "" = "$exec_pid" ]; then
	setsid $lpath > /dev/null 2>&1 &
	exec_pid=$(pidof $exec_name)
	echo "start : $exec_pid [$lpath]"
else
	echo "'$exec_name' already run: $exec_pid [$lpath]"
fi
