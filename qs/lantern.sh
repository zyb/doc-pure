#! /bin/bash

nmap 127.0.0.1 -p 12251 | grep open
port_exist=$(echo $?)
if [ "0" == "$port_exist" ]; then
  echo "lantern port already used."
  exit
fi

if [ ! -d /tmp/lanterntmp ]; then
  mkdir /tmp/lanterntmp
fi
tmpfile=$(mktemp /tmp/lanterntmp/log.XXXXXXXXXXXXX)

setsid lantern -addr 127.0.0.1:12251 -uiaddr 127.0.0.1:12259 > $tmpfile 2>&1 &
ps aux | grep "lantern " | grep -v grep
echo "lantern log: $tmpfile"
