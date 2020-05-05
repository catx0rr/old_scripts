#!/bin/bash

sudo echo Configuring boot entry..
sleep 1.25

menuentry='# Appended Configured Boot Menus
menuentry "Reboot" {
reboot
}

menuentry "Shutdown" {
halt
}'

sudo echo -e "$menuentry" >> /etc/grub.d/40_custom
echo "Updating grub.."
sleep 1.25
sudo update-grub
read -p "Restart Now? [y/N]: " choice
case $choice in
	[y,Y]es|y|Y) sudo init 6 ;;
	[n,N]o|n|N) exit ;;
		*) echo "None of the choice. Reboot to verify changes."
esac

