#! /bin/bash

ip link set wlp3s0b1 down
ip link set enp12s0 up
dhcpcd enp12s0
