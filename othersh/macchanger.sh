#!/bin/bash

macchange() {
read -p "Enter interface name: " iface
sudo ifconfig $iface down
sudo macchanger -r $iface
sudo ifconfig $iface up
echo "Done."
}

macchangesave() {
read -p "Enter interface name: " iface
sudo ifconfig $iface down
sudo macchanger -r $iface > $dir/ether.txt
sudo ifconfig $iface up
cat $dir/ether.txt
echo "Done."
}
while true; do

echo "Change Mac Address"
echo "This requires macchanger and root privilege"
echo
read -p "Do you want to save this to file? [y/N]: " choice
case $choice in
		[y,Y]es|YES|y|Y) read -p "Specify the directory path:" dir
				             if [ ! -d $dir ] ; then
				                  echo "Directory not found." && sleep 1.3 ; clear
				             else #start save file
				                  macchangesave && exit
				             fi ;;
		[n,N]o|NO|n|N) macchange && exit;;
		            *) echo "You must choose an option!"
		               echo
esac
done
