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

stepheader "Partition the disks"
/bin/bash

stepheader "Format the partitions"
/bin/bash

stepheader "Mount the partitions"
/bin/bash

stepheader "Install the base packages"
echo -e "\nsuch as: pacstrap -i /mnt/xxx base grub docker networkmanager"
echo -e "Don't forget to config network && modify /etc/pacman.d/mirrorlist\n"
/bin/bash

stepheader "Generate an fstab"
echo -e "\nsuch as: genfstab -U -p /mnt/xxx >> /mnt/xxx/etc/fstab"
echo -e "Don't forget to check the '/mnt/xxx/etc/fstab' file\n"
/bin/bash

clear
echo -e "\n\n"
echo "# Base System Install Over!"
echo -e "\nafter arch-chroot, use config shellscript for configure guide."
echo -e "press enter to exit."
echo -e "\n\n"
read
