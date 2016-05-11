#!/bin/bash

IN="LVDS-1"
EXT="VGA-1"
MODE=""

if [ "$1" == "17" ]; then
	MODE="--mode 1024x768"
elif [ "$1" == "86" ]; then
	MODE="--mode 800x600"
fi

if (xrandr | grep "$EXT" | grep "+")
	then
	xrandr --output $EXT --off --output $IN --auto
elif (xrandr | grep "$EXT" | grep " connected")
	then
	xrandr --output $IN $MODE --auto --output $EXT --right-of $IN --auto
  herbstclient detect_monitors
fi
