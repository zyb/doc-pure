#! /bin/bash

webip=127.0.0.1
webport=2525
webhome="/home/zyb/data/github/webui-aria2"
aria2home="/home/zyb/Desktop/aria2"

webexec="python -m http.server --bind $webip $webport"
aria2exec="aria2c --enable-rpc --rpc-listen-all"

aria2pid=$(ps aux | grep "$aria2exec" | grep -v grep | awk '{print $2}')
if [ "" == "$aria2pid" ]; then
	cd $aria2home && nohup $aria2exec > /dev/null 2>&1 &
fi
echo "aria2 run '$aria2pid': $aria2exec [$aria2home]"

webpid=$(ps aux | grep "$webexec" | grep -v grep | awk '{print $2}')
if [ "" == "$webpid" ]; then
	cd $webhome && nohup $webexec > /dev/null 2>&1 &
fi
echo "aria2 webui run '$webpid': $webexec [$webhome]"

firefox --new-tab $webip:$webport
