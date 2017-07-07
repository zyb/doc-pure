#! /bin/bash

id="$1"

echo "url: http://www.apache.wiki/display/Index/SS"
echo "jp.kingss.me 21006 ApacheCN_110 aes-256-cfb"
echo "sf1.kingss.me 21006 ApacheCN_110 aes-256-cfb"
echo "sf2.kingss.me 21006 ApacheCN_110 aes-256-cfb"
echo "ca.kingss.me 21006 ApacheCN_110 aes-256-cfb"
echo "uk.kingss.me 21006 ApacheCN_110 aes-256-cfb"
echo ""
echo "216.189.158.147 52940 doub.io52940 chacha20"
echo "64.137.243.186 52940 doub.io52940 chacha20"
echo "64.137.208.113 52940 doub.io52940 chacha20"
echo "45.62.245.70 52940 doub.io52940 chacha20"
echo "104.160.173.141 52940 doub.io52940 chacha20"
echo ""
echo "104.224.161.182 666 cccwszsf chacha20-ietf"
echo "138.128.212.173 1026 RJTPLd rc4-md5"
echo ""
echo "104.223.3.138 6376 123456.* aes-256-cfb"
echo ""
echo "144.168.62.206 7739 zA1h8jCBoO aes-256-cfb"
echo "------------------------------------------------"

info="144.168.62.206 7739 zA1h8jCBoO aes-256-cfb"
info="104.223.3.138 6376 123456.* aes-256-cfb"
info="138.128.212.173 1026 RJTPLd rc4-md5"
info="107.170.207.19 4321 epix4321epix4321 chacha20"
info="45.55.114.107 4321 epix4321epix4321 chacha20"

#cat Desktop/ss.htm | grep "text=ss://" | awk -F'text=ss://' '{print $2}' | awk -F'"' '{"echo "$1" | base64 -d && echo " | getline r; print r;}' | awk -F '[:@]' '{print "curl http://freeapi.ipip.net/"$3" && echo \"  "$3" "$4" "$2" "$1"\" && sleep 1"}' | bash

function ssconn() {

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

}

while true; do

if [[ "doub" == "$id" ]]; then
echo "------------------------------------------------"
# doub ip list
curl https://doub.io/sszhfx/ | grep "url=ss://" | awk -F'ss://' '{print $2}' | awk -F'"' '{print "echo "$1" | base64 -d && echo "}' | bash | awk -F '[:@]' '{print "curl http://freeapi.ipip.net/"$3" && echo \"  "$3" "$4" "$2" "$1"\" && sleep 1"}' | bash
else
ssconn
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

done
