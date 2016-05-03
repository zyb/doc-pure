#! /bin/bash

xinput list
echo "---------------------------"
xinput list-props 'SynPS/2 Synaptics TouchPad'
echo "---------------------------"
echo "xinput set-prop 11 139 0"
