#!/bin/bash
##################################################################################################
#This script backups the home directory of the user in a specified path                          #
#-feel free to modify and redistribute                                                           #
##################################################################################################

bakdir="$HOME"
baklist="$bakdir/backup.txt"

banner='
    __  __                       ____  ___    __ __
   / / / /___  ____ ___  ___    / __ )/   |  / //_/
  / /_/ / __ \/ __ `__ \/ _ \  / __  / /| | / ,<   
 / __  / /_/ / / / / / /  __/ / /_/ / ___ |/ /| |  
/_/ /_/\____/_/ /_/ /_/\___(_)_____/_/  |_/_/ |_|  
by catx0rr                                        
                                                  '
clear
echo -e "$banner"
echo "Backup your files without wasting your time"
echo
ls $bakdir > $baklist
read -p "This may take time to back up your home directory. Continue? (y/n): " cont
case $cont in
	[y,Y]es|y|Y)read -p "Specify a directory path: " dirpath
          if [ ! -d $dirpath ] ; then
               echo "Directory not found." && sleep 1.3 ; clear ; exit
          #start backup
          else 
               echo
               echo "Back up list created in $baklist"
               
               for bak in $(cat $baklist)
               do
                   echo "Backing up the files: $bak"
                   sleep 0.35
                   sudo cp -r $bakdir/$bak $dirpath/$bak 2>/dev/null
                   sudo chown $user:$user $bakdir/*
               done
               echo "Files successfully backed up!"
         fi ;;
	[n,N]o|n|N) echo "Exiting..." && sleep 1 ; clear ; exit ;;
			 *) echo "Invalid selection!" && sleep 1.3 ; clear
esac
