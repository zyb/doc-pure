#!/bin/bash

IN="DP1"
EXT="eDP1"
MODE=""

if [ "$1" == "11" ]; then
	MODE="--mode 1920x1080"
elif [ "$1" == "17" ]; then
	MODE="--mode 1024x768"
elif [ "$1" == "86" ]; then
	MODE="--mode 800x600"
elif [ "$1" == "21" ]; then
	MODE="--mode 2560x1440"
fi

if (xrandr | grep -w "$EXT" | grep "+")
	then
	xrandr --output $EXT --off --output $IN --auto
elif (xrandr | grep -w "$EXT" | grep " connected")
	then
	xrandr --output $IN $MODE --auto --output $EXT --right-of $IN --auto
  herbstclient detect_monitors
fi
