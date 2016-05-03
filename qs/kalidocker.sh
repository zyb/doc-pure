#! /bin/bash

rmflag="--rm"
if [ "" != "$1" ]; then
	rmflag=""
fi

docker run -it --net=host --privileged=true $rmflag -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:/root/.Xauthority:ro -e XAUTHORITY=/root/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix:ro --name="kali" zyb/kalilinux:latest /bin/bash
