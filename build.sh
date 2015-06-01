DROOTFS=rootfs
mkdir -p $DROOTFS
rc=$?
if [[ $rc != 0 ]] ; then
        echo Failed to create rootfs folder
        exit 1
fi

debootstrap --arch armhf --foreign jessie $DROOTFS http://ftp.de.debian.org/debian/
rc=$?
if [[ $rc != 0 ]] ; then
        echo debootstrap first stage failed
        exit 1
fi

modprobe binfmt_misc
rc=$?
if [[ $rc != 0 ]] ; then
        echo failed to load binfmt_misc driver
        exit 1
fi

cp /usr/bin/qemu-arm-static $DROOTFS/usr/bin/
cp vsdeb.sh $DROOTFS/usr/bin/
mkdir -p $DROOTFS/dev/pts
mount devpts $DROOTFS/dev/pts -t devpts
mount -t proc proc $DROOTFS/proc
chroot $DROOTFS /bin/bash -c "/usr/bin/vsdeb.sh"
rc=$?
if [[ $rc != 0 ]] ; then
        echo chroot into rootfs failed
        exit 1
fi
