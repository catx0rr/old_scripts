#!/bin/bash

initdpath='/etc/init.d'

sudo echo "#!/bin/bash" > $initdpath/macchange.sh
sudo echo >> $initdpath/macchange.sh
sudo echo ifconfig wlan0 down >> $initdpath/macchange.sh
sudo echo macchanger -r wlan0 >> $initdpath/macchange.sh
sudo echo ifconfig wlan0 up >> $initdpath/macchange.sh
sudo chmod +x $initdpath/macchange.sh
sudo update-rc.d macchange.sh defaults 100

