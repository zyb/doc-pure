#! /bin/bash

if [ "" = "$1" ]; then
	echo "need lantern exec path"
	exit 1
else
	if [ "d" = "$1" ]; then
		default="~/d/github/lantern/lantern_linux_amd64"
		lpath="$default"
	else
		lpath="$1"
	fi
fi

echo "nohup $lpath > /dev/null 2>&1 &"
