#!/bin/bash

clear
echo  "enter 1st-3rd IP octet:"
read -p  "EX: 192.168.0:  " firsthird
read -p "enter 4th octet: " last ; echo -en "\n"
sleep 1
echo "Connecting to SSH.."
echo -en "\n"

while [ "$last" != "256" ]; do
  ssh pi@$firsthird.$last
  echo "SSHing at @$firsthird.$last" 
  sleep 1
  last=$[ $last + 1 ]
done 
