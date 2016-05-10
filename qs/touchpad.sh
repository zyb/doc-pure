#! /bin/bash

touchpad='SynPS/2 Synaptics TouchPad'
touchpadable='Device Enabled'
d=$(xinput list | grep "$touchpad" | awk '{print $6}' | awk -F= '{print $2}')
s=$(xinput list-props $d | grep "$touchpadable" | awk '{print $3}' | awk -F\( '{print $2}' | awk -F\) '{print $1}')

cmd="xinput set-prop $d $s 0"
echo $cmd
`$cmd`

#xinput list
#echo "---------------------------"
#xinput list-props 'SynPS/2 Synaptics TouchPad'
#echo "---------------------------"
#echo "xinput set-prop 11 139 0"
