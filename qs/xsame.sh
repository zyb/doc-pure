#! /bin/bash

if [[ "" == "$1" || "" == "$2" ]]; then
	echo "need 2 params"
	exit 1
fi

#xrandr --output $1 --mode 1920x1080
xrandr --output $2 --same-as $1 --auto
xrandr --output $2 --mode 1920x1080
