#! /bin/bash

#sleep 0.3
#scrot -s -e 'mv $f ~/sshot/'

cmd="shutter -n -e -s"
pid=$(ps aux | grep "$cmd" | grep -v grep | awk '{print $2}' )
kill $pid
`timeout 120 $cmd`
