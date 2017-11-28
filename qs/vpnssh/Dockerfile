FROM base/archlinux
MAINTAINER zyb

RUN \
echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
pacman -Syu && \
pacman -S --noconfirm openvpn openssh nmon && \
pacman -Scc --noconfirm && \
mkdir -p /var/run/sshd && \
ssh-keygen -A && \
\
echo -e '#! /bin/bash \n\n\
/usr/sbin/sshd -D & \n\
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa \n\
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \n\
ssh -o StrictHostKeyChecking=no -qTNf -D 0.0.0.0:25259 root@127.0.0.1 \n\
mkdir -p /dev/net \n\
mknod -m 0666 /dev/net/tun c 10 200 \n\
openvpn --config /openvpn.ovpn \n\
' >> /run.sh && \
chmod +x /run.sh

CMD /run.sh
