#! /bin/bash

if [ "$1" == "list" ]; then
	~/zdata/software/genymotion/genyshell -c "devices list"
	exit 0
fi

setsid ~/zdata/software/genymotion/player --vm-name "android4.3tp" > /dev/null 2>&1 &
