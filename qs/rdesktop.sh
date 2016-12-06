#! /bin/bash
if [ "kill" == "$1" ]; then
	p=`pidof rdesktop`
	kill $p
	exit 0
fi

# tcZAflwsyhy2yh!Q#E%T&U(O

resolution=$(xrandr -q | awk '/Screen 0/ {print int($8) $9 int($10-10)}' | sed 's/,//g')
#resolution="99%"
rd="rdesktop -a 16 -P -f -g $resolution -t -z -r sound:off -r disk:MyHome=/home/zyb"
if [ "$2" == "11" ]; then
	rd="rdesktop -a 16 -P -f -g 1920x1080 -t -z -r sound:off -r disk:MyHome=/home/zyb"
fi

if [ "" == "$1" ]; then
  addr=172.16.59.13:52138
  user=binzhang3
elif [ "jkwu" == "$1" ]; then
  addr=116.213.140.67:18181
  user=jkwu
elif [ "zhangbin" == "$1" ]; then
	addr=117.121.45.227:18180
	user=zhangbin
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
