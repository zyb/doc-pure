#! /bin/bash

# 针对ssr解码
# xxxx | awk '{print "echo -n " $1 " | base64 -d 2>/dev/null | xargs echo"}' | bash | awk -F"[:/]" '{print "echo -n " $6 " | base64 -d 2>/dev/null | xargs -I {} echo " $1,$2,"{}",$4}' | bash | awk '{print "curl http://freeapi.ipip.net/"$1" && echo \"  "$1" "$2" "$3" "$4"\" && sleep 1"}' | bash

#ssexe="sslocal"
ssexe="ss-local"
sslocalport=12250
sslocalip="127.0.0.1"

unset ssip
unset ssport
unset sspw
unset ssmd
unset info

#cat Downloads/ss.htm | grep "=ssr://" | awk -F"=ssr://" '{print $2}' | awk -F\" '{print "echo -n " $1 " | base64 -d 2>/dev/null | xargs echo"}' | bash | awk -F":|@" '{print "curl http://freeapi.ipip.net/"$3" && echo \"  "$3" "$4" "$2" "$1"\" && sleep 1"}' | bash
#sed ":label;N;s/<\/td>\n<td//g;t label" Downloads/ss.htm | grep "=ssr://" | sed "s/<del><\/del>//g" | grep -v "<del>" | awk -F"=ssr://" '{print $2}' | awk -F\" '{print "echo -n " $1 " | base64 -d 2>/dev/null | xargs echo"}' | bash | awk -F"[:/]" '{print "echo -n " $6 " | base64 -d 2>/dev/null | xargs -I {} echo " $1,$2,"{}",$4}' | bash | awk '{print "curl http://freeapi.ipip.net/"$1" && echo \"  "$1" "$2" "$3" "$4"\" && sleep 1"}' | bash
#sed "s/<tr>/<tr>\n/g" Downloads/ss.htm | sed "s/<\/tr>/<\/tr>\n/g" | grep "=ssr://" | sed "s/<del><\/del>//g" | grep -v "<del>" | awk -F"=ssr://" '{print $2}' | awk -F\" '{print "echo -n " $1 " | base64 -d 2>/dev/null | xargs echo"}' | bash | awk -F"[:/]" '{print "echo -n " $6 " | base64 -d 2>/dev/null | xargs -I {} echo " $1,$2,"{}",$4}' | bash | awk '{print "curl http://freeapi.ipip.net/"$1" && echo \"  "$1" "$2" "$3" "$4"\" && sleep 1"}' | bash


echo "------------------------------------------------"
#info=`curl -k https://freessr.win/ | egrep -A 4 --color=auto "^\s*<div class=" | grep -A 3 "服务器地址" | sed "s/<\/h4>//g" | awk -F: '{print $2}' | tr "\n" " "`
#echo $info
#echo "-------------------"

#ss=$(curl -POST https://cli.im/Api/Browser/deqr -d 'data=https%3A%2F%2Fen.ss8.fun%2Fimages%2Fserver03.png' | jq -r '.data.RawData' | awk -F'ss://' '{print $2}')
#info=$(echo -n $ss | base64 -d 2>/dev/null | awk -F"[:@]" '{print $3, $4, $2, $1}')
#echo $info
#echo "-------------------"

#ss=$(curl -POST https://cli.im/Api/Browser/deqr -d 'data=https%3A%2F%2Fen.ss8.fun%2Fimages%2Fserver02.png' | jq -r '.data.RawData' | awk -F'ss://' '{print $2}')
#info=$(echo -n $ss | base64 -d 2>/dev/null | awk -F"[:@]" '{print $3, $4, $2, $1}')
#echo $info
#echo "-------------------"

#info=$(curl -POST https://cli.im/Api/Browser/deqr -d 'data=https%3A%2F%2Fen.ss8.fun%2Fimages%2Fserver01.png' | jq -r '.data.RawData' | awk -F'ss://' '{print $2}' | xargs echo -n  | base64 -d 2>/dev/null | awk -F"[:@]" '{print $3, $4, $2, $1}')
#echo $info
#echo "-------------------"
info="138.68.236.77 443 google.com chacha20-ietf-poly1305"
#info="64.137.201.248 1572 doub.io/sszhfx/*doub.bid/sszhfx/*1392 chacha20"
echo $info
echo "------------------------------------------------"
echo "use: $info"


function ssraddr() {
	info=$(echo -n $1 | base64 -d 2>/dev/null | awk -F"[:/]" '{print "echo -n " $6 " | base64 -d 2>/dev/null | xargs -I {} echo " $1,$2,"{}",$4}' | bash)
}

function ssaddr() {
	info=$(echo -n $1 | base64 -d 2>/dev/null | awk -F"[:@]" '{print $3, $4, $2, $1}')
}

function ssconn() {
	exist_pid=$(ps aux | grep "$ssexe " | grep -v grep | tail -n 1 | awk '{print $2}')
	if [[ "" != "$exist_pid" ]]; then
		echo "sslocal already run: $exist_pid, kill it."
		kill $exist_pid
		sleep 0.5
	fi
 
	nmap 127.0.0.1 -p $sslocalport | grep open
	port_exist=$(echo $?)
	if [ "0" == "$port_exist" ]; then
		echo "sslocal port already used."
		exit
	fi
 
	if [ ! -d /tmp/sstmp ]; then
		mkdir /tmp/sstmp
	fi
	tmpfile=$(mktemp /tmp/sstmp/sslog.XXXXXXXXXXXXX)
	setsid $ssexe -s $ssip -p $ssport -k $sspw -m $ssmd -b $sslocalip -l $sslocalport -v > $tmpfile 2>&1 &
sleep 1
	ps aux | grep "$ssexe " | grep -v grep
	exec_pid=$(ps aux | grep "$ssexe " | grep -v grep | awk '{print $2}')
	echo "sslocal start pid: $exec_pid, log: $tmpfile"
}


isFirst="true"
while true; do
  if [[ "" != "$info" ]]; then
	  ssip=$(echo $info | cut -d" " -f 1)
	  ssport=$(echo $info | cut -d" " -f 2)
	  sspw=$(echo $info | cut -d" " -f 3)
	  ssmd=$(echo $info | cut -d" " -f 4)

	  ssconn
  fi

	echo "------------------------------------------------"
	printf "info:(ip port pw md) "
	read info
done