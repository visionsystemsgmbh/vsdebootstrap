#!/bin/sh

sernum=`onrisctool -s | awk -F" " '/Serial/ {print $3}'`

viavpn_pkg=viavpn-$sernum.zip

if [ ! -e /mnt/$viavpn_pkg ]; then
	clear
	echo "No viaVPN data file for device with serial number $sernum found"
	exit 1
fi

echo Extracting files

mkdir -p /tmp/vscom
unzip -o /mnt/$viavpn_pkg -d /tmp/vscom

echo Installing certificates
mkdir -p /opt/viavpn
unzip -o /tmp/vscom/viavpn-data.zip -d /opt/viavpn

echo Installing required Debian packages
dpkg -i /tmp/vscom/*.deb
yes "Y" | apt-get install -f

echo Installation completed
