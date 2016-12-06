#! /bin/bash

if [ "" = "$1" ]; then
	default="/home/zyb/data/github/lantern/lantern_linux_amd64"
	lpath="$default"
else
	lpath="$1"
fi

exec_pid=$(pidof $lpath)
if [ "" = "$exec_pid" ]; then
	mkdir -p /tmp/lantern
	tmpfile=$(mktemp /tmp/lantern/lantern.log.XXXXXXXXXXXXX)
	setsid $lpath --addr 127.0.0.1:12258 > $tmpfile 2>&1 &
	sleep 0.5
	exec_pid=$(pidof $lpath)
	echo "start : $exec_pid [$lpath], log file: $tmpfile"
else
	echo "'$lpath' already run: $exec_pid"
fi
