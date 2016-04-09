#! /bin/bash

curr=$(dirname $_)

setsid sslocal -c $curr/ss/pytrade.xyz > /dev/null 2>&1 &
