#!/bin/sh

/debootstrap/debootstrap --second-stage

# setup repositories
cd /root
cat <<END > /etc/apt/sources.list
deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free
deb http://ftp.debian.org/debian/ jessie main contrib non-free
deb-src http://ftp.debian.org/debian/ jessie main contrib non-free
END

# prepare fstab
cat <<END > /etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/mmcblk0p2   /           auto   errors=remount-ro   0   1
END

export LANG=C

# specify hostname
echo baltos > /etc/hostname

apt-get update

# install core packages
yes "Y" | apt-get install mc dstat lsof whois tmux vim usbutils psmisc policykit-1 bzip2 libconfig9 minicom rcconf

# install network packages
yes "Y" | apt-get install openvpn can-utils openssh-server modemmanager iw wpasupplicant hostapd ethtool ser2net telnet telnetd libsocketcan2 nuttcp ppp ntp ntpdate socat

# install firmware
yes "Y" | apt-get install firmware-realtek firmware-ti-connectivity firmware-ralink

# install packages for software development
yes "Y" | apt-get install git tig quilt cmake strace swig libtool automake autoconf libudev-dev pkg-config g++ clang python-dev libconfig-dev

# install local packages
dpkg -i /tmp/packages/*.deb
yes "Y" | apt-get install -f
apt-get clean
rm -fr /tmp/packages

# create default password for root
echo "root:sPrpUyL3oeuok" | chpasswd -e

# handle fs-overlay
tar xf /tmp/local-fs-overlay.tar -C /
rm /tmp/local-fs-overlay.tar
if [ -e /tmp/external-fs-overlay.tar ]; then
	tar xf /tmp/external-fs-overlay.tar -C /
	rm /tmp/external-fs-overlay.tar
fi

exit
