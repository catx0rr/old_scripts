#!/bin/bash
##################################################################################################
#This is the restore script fot the back up directory of the user in a specified path            #
#-feel free to modify and redistribute                                                           #
##################################################################################################
resdir="$HOME"
reslist="$resdir/restore.txt"

banner='
    ____            __  ____            __  __                   
   / __ \___  _____/ /_/ __ \________  / / / /___  ____ ___  ___ 
  / /_/ / _ \/ ___/ __/ / / / ___/ _ \/ /_/ / __ \/ __ `__ \/ _ \
 / _, _/  __(__  ) /_/ /_/ / /  /  __/ __  / /_/ / / / / / /  __/
/_/ |_|\___/____/\__/\____/_/   \___/_/ /_/\____/_/ /_/ /_/\___/ 
by catx0rr        
                                                 '
clear
echo -e "$banner"
echo "Restore your files without wasting your time"
echo
read -p "This may take time to restore your home directory files. Continue? (y/n): " cont
case $cont in
	[y,Y]es|y|Y)read -p "Specify your restore directory path: " dirpath
          if [ ! -d $dirpath ] ; then
               echo "Directory not found." && sleep 1.3 ; clear ; exit
          #start restore
          else 
               echo
	       ls $dirpath > $reslist
               echo "Restore list created in $reslist"
               
               for res in $(cat $reslist)
               do
                   echo "Restoring files: $res"
                   sleep 0.35
                   sudo cp -rf $dirpath/$res $resdir/$res 2>/dev/null
               done
               echo "Files successfully restored!"
         fi ;;
	[n,N]o|n|N) echo "Exiting..." && sleep 1 ; clear ; exit ;;
			 *) echo "Invalid selection!" && sleep 1.3 ; clear
esac

