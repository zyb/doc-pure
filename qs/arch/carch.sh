#! /bin/bash

stepinc=0
stepheader()
{
  clear
  stepinc=$[ $stepinc + 1 ]
  echo "Step $stepinc: $1"
  echo -e "\nPress Enter To Continue Or 'Ctrl+c' To Exit.\n"
  read
}

execmd()
{
  if [ 0 -eq flag ]; then
    echo "$1"
  else 
    echo -e "\npress enter to execute '$1' command"
    read
    $1
  fi
}

stepheader "Locale"
flag=0
while [ $flag -eq 2 ]; do
  execmd "vim /etc/locale.gen" $flag
  execmd "locale-gen" $flag
  execmd "echo LANG=en_US.UTF-8 > /etc/locale.conf" $flag
  execmd "export LANG=en_US.UTF-8" $flag
  flag=$[ $flag + 1 ]
done

stepheader "Time zone"
flag=0
while [ $flag -eq 2 ]; do
  execmd "ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime" $flag
  flag=$[ $flag + 1 ]
done

stepheader "Hardware clock"
flag=0
while [ $flag -eq 2 ]; do
  execmd "hwclock --systohc --utc" $flag
  flag=$[ $flag + 1 ]
done

stepheader "Hostname"
flag=0
while [ $flag -eq 2 ]; do
  execmd "echo zybu > /etc/hostname" $flag
  flag=$[ $flag + 1 ]
done

stepheader "root password"
flag=0
while [ $flag -eq 2 ]; do
  execmd "passwd" $flag
  flag=$[ $flag + 1 ]
done

stepheader "bootloader"
flag=0
while [ $flag -eq 2 ]; do
  execmd "grub-install --target=i386-pc --recheck /dev/sdX" $flag
  execmd "grub-mkconfig -o /boot/grub/grub.cfg" $flag
  flag=$[ $flag + 1 ]
done


clear
echo -e "\n\n"
echo "# System Configure Over!"
echo -e "press enter to exit."
echo -e "\n\n"
read
