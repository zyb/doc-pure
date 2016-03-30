#! /bin/bash

mount -o uid=1000,gid=100,fmask=003,dmask=002 /dev/sda2 /mnt/c
mount -o uid=1000,gid=100,fmask=003,dmask=002 /dev/sda3 /mnt/d
#mount /dev/sdb5 /mnt/u
