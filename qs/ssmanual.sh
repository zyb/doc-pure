#! /bin/bash

id="$1"

echo "url: http://www.apache.wiki/display/Index/SS"
echo "jp.kingss.me 20881 ApacheCN_007 aes-256-cfb"
echo "sf1.kingss.me 20881 ApacheCN_007 aes-256-cfb"
echo "sf2.kingss.me 20881 ApacheCN_007 aes-256-cfb"
echo "ca.kingss.me 20881 ApacheCN_007 aes-256-cfb"
echo "uk.kingss.me 20881 ApacheCN_007 aes-256-cfb"
echo ""
echo "144.168.62.206 7739 zA1h8jCBoO aes-256-cfb"
echo "67.21.78.225 678 ntdtv.com chacha20"
echo "98.142.143.181 2333 MDM4OGQxMz aes-256-cfb"
echo "198.46.242.216 443 +hAxN=OFj8dD chacha20"
echo "142.4.124.156 15185 VaPzwK aes-256-cfb"

while true; do

if [[ "doub" == "$id" ]]; then
echo "------------------------------------------------"
# doub ip list
curl https://doub.io/sszhfx/ | grep "url=ss://" | awk -F'ss://' '{print $2}' | awk -F'"' '{print "echo "$1" | base64 -d && echo "}' | bash | awk -F '[:@]' '{print "curl http://freeapi.ipip.net/"$3" && echo \"  "$3" "$4" "$2" "$1"\" && sleep 1"}' | bash
fi

echo "------------------------------------------------"
printf "info:(ip port pw md) "
read info

id=""
if [[ "" == "$info" ]]; then
	continue
elif [[ "doub" == "$info" ]]; then
	id=$info
	continue
fi

kv=($info)
echo ${kv[*]}
ip=${kv[0]}
port=${kv[1]}
pw=${kv[2]}
md=${kv[3]}

pid=$(ps aux | grep "sslocal " | grep -v grep | tail -n 1 | awk '{print $2}')
if [[ "" != "$pid" ]]; then
  echo "sslocal already run: $pid, kill it."
  kill $pid
  sleep 0.5
fi

nmap 127.0.0.1 -p 12250 | grep open
port_exist=$(echo $?)
if [ "0" == "$port_exist" ]; then
  echo "sslocal port already used."
  exit
fi

if [ ! -d /tmp/sstmp ]; then
  mkdir /tmp/sstmp
fi
tmpfile=$(mktemp /tmp/sstmp/sslog.XXXXXXXXXXXXX)
setsid sslocal -s $ip -p $port -k $pw -m $md -b 127.0.0.1 -l 12250 -v > $tmpfile 2>&1 &
sleep 0.5
exec_pid=$(ps aux | grep sslocal | grep -v grep | awk '{print $2}')
ps aux | grep sslocal
echo "sslocal start: $exec_pid, log: $tmpfile"

done
