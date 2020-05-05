#!/bin/bash
##################################################################################################
#Debian Auto updater                                                                             #
#feel free to modify and redistribute                                                            #
##################################################################################################

deba='
    ____  __________        ___   __  ____________ 
   / __ \/ ____/ __ )      /   | / / / /_  __/ __ \
  / / / / __/ / __  |_____/ /| |/ / / / / / / / / /
 / /_/ / /___/ /_/ /_____/ ___ / /_/ / / / / /_/ / 
/_____/_____/_____/     /_/  |_\____/ /_/  \____/  
by catx0rr                                        '

f_upd(){
clear
echo -e "$deba"
echo
echo "1)apt update              2)apt upgrade"
echo
echo "3)apt full-upgrade        4)apt dist-upgrade"
echo
read -p "Make your choice >> " CHOICE
case $CHOICE in
    1)clear
      echo -e "$deba"
      echo "You chose apt update! updating.. "
      echo && sudo apt -y update && sleep 1.3 ; echo "Done!" ;;
    2)clear
      echo -e "$deba"
      echo "You chose apt upgrade! upgrading.. "
      echo && sudo apt -y upgrade && sleep 1.3 ; echo "Done!" ;;
    3)clear
      echo -e "$deba"
      echo "You chose apt full-upgrade! upgrading.. "
      echo &&sudo apt -y full-upgrade && sleep 1.3 ; echo "Done!" ;;
    4)clear
      echo -e "$deba"
      echo "You chose apt dist-upgrade! upgrading system.. "
      echo && sudo apt -y dist-upgrade && sleep 1.3 ; echo "Done!" ;;
    *)echo
      echo "Please select the correct number" && sleep 1.5 ; clear ;;
esac
}

f_upd
