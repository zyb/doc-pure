#! /bin/bash
shell_dir=$(cd "$(dirname "$0")"; pwd)

if [[ "run" == "$1" || "exec" == "$1" ]]; then
  param1=$1
  if [[ "" == "$2" ]]; then
    echo "need 2 params"
    exit 1
  fi 
  param2=$2
else
  echo "first param must be 'run' or 'exec'"
  exit 1
fi

vpndir=$shell_dir/vpnssh
vpnaccount=$vpndir/account
vpndocker=vpnssh
port=12253
currips=($(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 172.17.0.|grep -v inet6|awk '{print $2}'|tr -d "addr:"))
currip=${currips[0]}

systemctl status docker | grep running
ret=$(echo $?)
if [[ 0 -ne $ret ]]; then
  sudo systemctl start docker
fi

if [[ "exec" == "$param1" ]]; then
  sudo docker exec -it $(sudo docker ps -q -l) $param2
elif [[ "run" == "$param1" ]]; then
  nmap 127.0.0.1 -p $port | grep open
  ret=$(echo $?)
  if [[ 0 -eq $ret ]]; then
    echo "port already used: $port"
    exit 1
  fi

  sudo docker run -it --rm --cap-add=NET_ADMIN --dns 8.8.8.8 -p 127.0.0.1:$port:25259 -v $vpndir/$param2.ovpn:/openvpn.ovpn -v $vpnaccount:/account $vpndocker
fi

