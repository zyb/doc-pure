#! /bin/bash

rd="rdesktop -a 16 -P -g 98% -t -z -r sound:off"

if [ "" == "$1" ]; then
  addr=172.16.59.13:52138
  user=binzhang3
elif [ "jkwu" == "$1" ]; then
  addr=116.213.140.67:18181
  user=jkwu
else
  addr=$1
  user=$2
fi

if [ "" == "$user" ]; then
  rd="$rd $addr"
else
  rd="$rd $addr -u $user"
fi

`$rd`
