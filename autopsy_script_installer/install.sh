#!/bin/bash

####################  ################
## Autopsy Digital Forensics 4.14.0 ##
###################  #################

BANNER='
 ▄▄▄       █    ██ ▄▄▄█████▓ ▒█████   ██▓███    ██████▓██   ██▓
 ▒████▄     ██  ▓██▒▓  ██▒ ▓▒▒██▒  ██▒▓██░  ██▒▒██    ▒ ▒██  ██▒
 ▒██  ▀█▄  ▓██  ▒██░▒ ▓██░ ▒░▒██░  ██▒▓██░ ██▓▒░ ▓██▄    ▒██ ██░
 ░██▄▄▄▄██ ▓▓█  ░██░░ ▓██▓ ░ ▒██   ██░▒██▄█▓▒ ▒  ▒   ██▒ ░ ▐██▓░
  ▓█   ▓██▒▒▒█████▓   ▒██▒ ░ ░ ████▓▒░▒██▒ ░  ░▒██████▒▒ ░ ██▒▓░
   ▒▒   ▓▒█░░▒▓▒ ▒ ▒   ▒ ░░   ░ ▒░▒░▒░ ▒▓▒░ ░  ░▒ ▒▓▒ ▒ ░  ██▒▒▒ 
     ▒   ▒▒ ░░░▒░ ░ ░     ░      ░ ▒ ▒░ ░▒ ░     ░ ░▒  ░ ░▓██ ░▒░ 
       ░   ▒    ░░░ ░ ░   ░      ░ ░ ░ ▒  ░░       ░  ░  ░  ▒ ▒ ░░  
             ░  ░   ░                  ░ ░                 ░  ░ ░     
	                                                            ░ ░  
		D I G I T A L   F O R E N S I C S   4.14.0
'
FILE=sleuthkit-java_4.8.0-1_amd64.deb
FILE2=autopsy-4.14.0.zip
DIR=$(pwd)/autopsy-4.14.0
LOG=/var/log/autopsy_install.log

clear
echo -e "$BANNER"
echo

echo [*] NOTE: May require sudo privileges to install.
echo
read -r -p "[*] Do you want to install Autopsy 4.14.0?(y/N): " reply

case $reply in
	[yY]|[eE]|[sS])
		echo
		echo "[+] Please wait while setup runs.."
		sleep 1
		if [ ! -f "$(pwd)/$FILE" ] && [ ! -f "$(pwd)/$FILE2" ]; then
			echo "[-] $FILE and $FILE2 is not yet downloaded. Downloading now.. Re run the script after downloading requirements."
			wget https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.8.0/sleuthkit-java_4.8.0-1_amd64.deb
			wget https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.14.0/autopsy-4.14.0.zip
			
		else
			echo "[*] Verifying $FILE and $FILE2.."
			sleep 1
			echo "[+] $FILE and $FILE2 found.. Installing other dependecies.. "
			sleep 2
			sudo touch /var/log/autopsy_install.log
			sudo chown $(whoami) /var/log/autopsy_install.log
			echo "$(date) __ https://download.bell-sw.com/pki/GPK-KEY-bellsoft" >> $LOG
			wget -q -O - https://download.bell-sw.com/pki/GPG-KEY-bellsoft | sudo apt-key add -
			echo "deb [arch=amd64] https://apt.bell-sw.com/ stable main" | sudo tee /etc/apt/sources.list.d/bellsoft.list
			sudo apt-get -y update
			sudo apt-get -y install testdisk
			echo "$(date) __ installed testdisk $(which testdisk)" >> $LOG
			sudo apt-get install -y bellsoft-java8-full
			java -version
			sleep 2
			sudo apt install -y $(pwd)/$FILE
			echo "$(date) __ $(locate sleuthkit | grep '/var')" >> $LOG

			echo "[+] Please wait until the package is extracted.."
			sleep 2
			sudo unzip $(pwd)/$FILE2
			sleep 5
			sudo chown -R $(whoami):$(whoami) $DIR
				
			cd $DIR && echo "export JAVA_HOME=/usr/lib/jvm/bellsoft-java8-full-amd64" >> $HOME/.bashrc
			source $HOME/.bashrc
			
			echo "$(date) __ $(echo $JAVA_HOME)" >> $LOG
			sleep 2
			sh $DIR/unix_setup.sh
			sleep 2
			echo
			sudo chown root /var/log/autopsy_install.log
			echo "[+] Installation done. You may execute autopsy on $(pwd)/autopsy-4.14.0/bin/autopsy"
			echo "[*] Logs stored in /var/log/autopsy_install.log"
		fi
	;;
*)
	echo "[-] Terminating Script.. "
	echo
	exit
	;;

esac
