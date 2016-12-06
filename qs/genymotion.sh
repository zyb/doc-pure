#! /bin/bash

if [ "$1" == "list" ]; then
	~/data/software/genymotion/genymotion/genyshell -c "devices list"
	exit 0
fi

setsid ~/data/software/genymotion/genymotion/player --vm-name "6.0" > /dev/null 2>&1 &
