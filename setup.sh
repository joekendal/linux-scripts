#!/bin/bash

sudo true

sudo sh -c 'echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolv.conf'

# Harden GNOME defaults
echo "[*] Updating settings"
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
echo "  Disabling microphone"
gsettings set org.gnome.desktop.privacy disable-microphone true
gsettings set org.gnome.desktop.privacy hide-identity true
gsettings set org.gnome.desktop.privacy remember-app-usage false
echo "  Disabling camera"
gsettings set org.gnome.desktop.privacy disable-camera true
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.privacy send-software-usage-stats false
echo "  Disabling location"
gsettings set org.gnome.system.location enabled false
echo "  Disabling autorun media"
gsettings set org.gnome.desktop.media-handling autorun-never true
echo "  Disabling automount"
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false

echo "[*] Updating packages"
sudo dnf update -y
echo "[+] Installing extra packages"
sudo dnf install vim haveged firejail ghc-compiler tor keepassxc make clang ffmpeg -y
echo "  Setting up firejail"
sudo firecfg 1> /dev/null
echo "[+] Installing Atom"
wget https://atom.io/download/rpm --output-document=/tmp/atom.rpm
sudo dnf install /tmp/atom.rpm -y
shred -n 3 -u /tmp/atom.rpm

echo "[+] Install Tor Browser"
curl -s https://openpgpkey.torproject.org/.well-known/openpgpkey/torproject.org/hu/kounek7zrdx745qydx6p59t9mqjpuhdf | gpg --import -
wget https://www.torproject.org/dist/torbrowser/9.0.1/tor-browser-linux64-9.0.1_en-US.tar.xz -O ~/Downloads/torbrowser-9.0.1.tar.xz
wget https://dist.torproject.org/torbrowser/9.0.1/tor-browser-linux64-9.0.1_en-US.tar.xz.asc -O ~/Downloads/torbrowser-9.0.1.tar.xz.asc
gpg --verify ~/Downloads/torbrowser-9.0.1.tar.xz.asc ~/Downloads/torbrowser-9.0.1.tar.xz
if [ $? -eq -1 ]
then
	echo "  Problem with signature"
	exit 1
else
sudo tar -xf ~/Downloads/torbrowser-9.0.1.tar.xz -C /opt/ && sudo chown -R joe /opt/tor-browser_en-US && sudo chgrp -R joe /opt/tor-browser_en-US && rm ~/Downloads/torbrowser-9.0.1.tar.xz
cd /opt/tor-browser_en-US/
./start-tor-browser.desktop --register-app
fi

sudo wget -nv https://www.wireless.bris.ac.uk/certs/eaproot/uob-net-ca.pem --output-document=/etc/ssl/certs/UoB-Net-CA.pem

sudo echo "7d9088c327577e1ccd9328db192f4abcec58dee0a513371c56d7c144ad68df33 */etc/ssl/certs/uob-net-ca.pem" | sha256sum -c -
if [ $? -eq -1 ]
then
	echo "  Problem verifying certificate hash"
	exit 1
else

