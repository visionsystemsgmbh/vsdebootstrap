#!/bin/sh

DROOTFS=rootfs
mkdir -p $DROOTFS
if [ $? -ne 0 ]; then
        echo Failed to create rootfs folder
        exit 1
fi

debootstrap --arch armhf --foreign jessie $DROOTFS http://ftp.de.debian.org/debian/
if [ $? -ne 0 ]; then
        echo debootstrap first stage failed
        exit 1
fi

modprobe binfmt_misc
if [ $? -ne 0 ]; then
        echo failed to load binfmt_misc driver
        exit 1
fi

cp /usr/bin/qemu-arm-static $DROOTFS/usr/bin/
cp vsdeb.sh $DROOTFS/usr/bin/

# check, if VS packages were already downloaded
debavail=0
for a in packages/*.deb; do
	test -f "$a" || continue
	debavail=1
done

# if no *.deb files found, download from VS FTP
if [ $debavail -eq 0 ]; then
	echo No *.deb files. Downloading ...
	wget -nd -m -r -e robots=off --no-parent --reject "index.html*" -P packages/ ftp://ftp.visionsystems.de/pub/multiio/OnRISC/Baltos/deb/
fi

# copy local packages and fs-overlay
cp -ra packages $DROOTFS/tmp
tar cf $DROOTFS/tmp/local-fs-overlay.tar -C fs-overlay/ .

if [ -e .vs_external ]; then
	source .vs_external
	if [ -d $VS_EXTERNAL/packages ]; then
		cp -ra $VS_EXTERNAL/packages $DROOTFS/tmp
	fi
	if [ -d $VS_EXTERNAL/fs-overlay ]; then
		tar cf $DROOTFS/tmp/external-fs-overlay.tar -C $VS_EXTERNAL/fs-overlay/ .
	fi
fi

mkdir -p $DROOTFS/dev/pts
mount devpts $DROOTFS/dev/pts -t devpts
mount -t proc proc $DROOTFS/proc
chroot $DROOTFS /bin/bash -c "/usr/bin/vsdeb.sh"
if [ $? -ne 0 ]; then
        echo chroot into rootfs failed
        exit 1
fi
