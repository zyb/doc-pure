#! /bin/bash

if [[ "" == "$1" ]]; then
  echo "need 1 params"
  exit 1
fi

sudo docker run -it --rm --cap-add=NET_ADMIN -p 12253:25259 -v /home/zyb/Downloads/protonvpn/4docker/account:/account -v /home/zyb/Downloads/protonvpn/4docker/$1:/openvpn.ovpn vpnssh
