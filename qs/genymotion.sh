#! /bin/bash

if [ "$1" == "list" ]; then
	~/datac/software/genymotion/genymotion/genyshell -c "devices list"
	exit 0
elif [ "$1" == "g" ]; then
	setsid ~/datac/software/genymotion/genymotion/genymotion &
	exit 0
elif [ "" != "$1" ]; then
	setsid ~/datac/software/genymotion/genymotion/player --vm-name "$1" > /dev/null 2>&1 &
	exit 0
fi

setsid ~/datac/software/genymotion/genymotion/player --vm-name "p7.0" > /dev/null 2>&1 &
