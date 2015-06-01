#1/bin/sh

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
yes "Y" | apt-get install openvpn can-utils openssh-server dstat modemmanager iw wpasupplicant lsof whois tmux vim

# install packages for software development
yes "Y" | apt-get install git tig cmake strace swig libtool automake autoconf libudev-dev pkg-config

# create default password for root
echo "root:sPrpUyL3oeuok" | chpasswd -e

exit
