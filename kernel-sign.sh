#!/bin/bash

: '
  This is a bash script for signing 3rd-party kernel modules
  when using UEFI SecureBoot.
'

if [ ! -d /root/.ssl ]; then
  echo "[*] Making certs folder /root/.ssl"
  mkdir /root/.ssl
fi
if [ ! -f /root/.ssl/MOK.priv ] || [ ! -f /root/.ssl/MOV.der ]; then
  echo "[*] Generating signing keys"
  openssl req -new -x509 -newkey rsa:4096 -keyout /root/.ssl/MOK.priv -outform DER -out /root/.ssl/MOK.der -nodes -subj "/CN=Name/"
  chmod 600 MOK.*
fi

if [ $1 ]
then
	module=$1
else
	echo -n "Enter kernel module name: "
	read module
fi
echo -n "Enter signing key: "
read KBUILD_SIGN_PIN
if [ `modinfo -n $module 2> /dev/null` ]
then
	[ "`hexdump -e '"%_p"' $(modinfo -n $module) | tail | grep signature`" ] && echo -e "[!] Module already signed" && exit
	echo "[*] Signing `modinfo -n $module`"
	KBUILD_SIGN_PIN=$KBUILD_SIGN_PIN /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/.ssl/MOK.priv /root/.ssl/MOK.der $(modinfo -n $module)
	modprobe $module
else
	echo "[!] Invalid kernel module $module"
fi

apt install mokutil > /dev/null 2>&1
mokutil --import /root/.ssl/MOK.der

echo "[!] Kernel module signed. When finished, reboot to complete process using the signing key."
