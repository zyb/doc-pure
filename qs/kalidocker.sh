#! /bin/bash

docker run -it --rm -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:/root/.Xauthority:ro -e XAUTHORITY=/root/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix:ro --net=host --name="kali" zyb/kalilinux:latest /bin/bash
