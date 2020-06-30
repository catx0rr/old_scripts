#!/bin/bash

# Install script for woeusb

winimage='
 _       __           __  _______ ____ 
| |     / /___  ___  / / / / ___// __ )
| | /| / / __ \/ _ \/ / / /\__ \/ __  |
| |/ |/ / /_/ /  __/ /_/ /___/ / /_/ / 
|__/|__/\____/\___/\____//____/_____/  Script!
by catx0rr

Windows Bootable Creator in Linux
github: https://github.com/slacka/WoeUSB'

echo -e "$winimage"
echo
sudo apt-get install -y \
   libwxgtk3.0-gtk3-dev \
   build-essential \
   checkinstall \
   devscripts \
   equivs \
   gdebi-core \
git clone https://github.com/slacka/WoeUSB.git && cd WoeUSB
./setup-development-environment.bash &&
sudo gdebi woeusb-build-deps_3.3.12-2-g5e9a3a7_all.deb
dpkg-buildpackage -uc -b
sudo gdebi ../woeusb_3.3.12-2-g5e9a3a7_amd64.deb
autoreconf --force --install
./configure
make
sudo make install
cd ..
rm -f woeusb*
rm -rf WoeUSB
sleep 0.5
echo "Done."
woeusb > woeusb.txt
less woeusb.txt
rm -f woeusb.txt
