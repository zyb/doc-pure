#! /bin/bash

if [ "" = "$1" ]; then
	echo "need 1 param, max backlight: $(cat /sys/class/backlight/intel_backlight/max_brightness), current backlight: $(cat /sys/class/backlight/intel_backlight/brightness)"
	exit
fi

echo $1 > /sys/class/backlight/intel_backlight/brightness
echo "current backlight: $(cat /sys/class/backlight/intel_backlight/brightness)"
