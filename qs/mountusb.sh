#! /bin/bash

mount -o uid=1000,gid=100,fmask=003,dmask=002 /dev/sdb2 /mnt/d
mount -o uid=1000,gid=100,fmask=003,dmask=002 /dev/sdb3 /mnt/c
mount /dev/sdb5 /mnt/u
