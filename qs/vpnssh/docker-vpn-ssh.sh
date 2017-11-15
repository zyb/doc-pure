#! /bin/bash

echo 'nameserver 8.8.8.8' > /etc/resolv.conf
echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
pacman -Syu
pacman -S --noconfirm openvpn openssh

mkdir -p /var/run/sshd
/usr/bin/ssh-keygen -A
nohup /usr/sbin/sshd -D &

ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
ssh -o StrictHostKeyChecking=no -qTNf -D 0.0.0.0:25259 root@127.0.0.1

mkdir -p /dev/net
mknod -m 0666 /dev/net/tun c 10 200
openvpn --config /openvpn.ovpn
