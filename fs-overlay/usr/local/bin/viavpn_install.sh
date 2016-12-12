#!/bin/sh

sernum=`onrisctool -s | awk -F" " '/Serial/ {print $3}'`

viavpn_pkg=viavpn-$sernum.zip

if [ ! -e /mnt/$viavpn_pkg ]; then
	if [ ! -e /mnt/viavpn-bundle.zip ]; then
		clear
		echo "No viaVPN data file for device with serial number $sernum found"
		exit 1
	else
		unzip /mnt/viavpn-bundle.zip $viavpn_pkg -d /tmp/vscom
		if [ ! -e /tmp/vscom/$viavpn_pkg ]; then
			clear
			echo "No viaVPN data file for device with serial number $sernum found"
			exit 1
		fi
	fi
fi

echo Extracting files

mkdir -p /tmp/vscom
unzip /mnt/$viavpn_pkg -d /tmp/vscom

echo Installing certificates
mkdir -p /opt/viavpn
unzip /tmp/vscom/viavpn-data.zip -d /opt/viavpn/data

echo Installing required Debian packages
apt update
dpkg -i /tmp/vscom/*.deb
yes "Y" | apt-get install -f
