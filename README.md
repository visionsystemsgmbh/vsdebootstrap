OnRISC Debian Image Creator
===========================

Overview
--------

OnRISC Debian Image Creator is a set of bash scripts, that help to produce
a custom Debian image using debootstrap and QEMU. The scripts provide basic
packages and configuration files and can be modified on order to add
additional Debian packages, configuration files etc.

Dependencies
------------

deboostrap needs QEMU for the second stage, i.e. execute commands as
if being on the real ARM hardware. Execute following command:

`apt-get install qemu-system-arm qemu-user-static`

build.sh
--------

build.sh is the main script, that must be run first. It creates a rootfs
folder specified in DROOTFS variable. You can change DROOTFS to /mnt, i.e.
mount folder where you've mounted the second partition of your SD card.
This would create Debian image directly on the SD card.

After creating the rootfs folder build.sh invokes debootstrap's fisrt
stage, that creates basic root file system. Then vsdeb.sh and QEMU will
be copied to the newly created rootfs and executed via chroot.

Custom configuration files, packages etc. must be copied to the final rootfs
via build.sh.

vsdeb.sh
--------

vsdeb.sh will be executed in the virtual machine. This script installs
additional Debian packages, creates root password etc.

So far additional packages will be installed in two steps:

1. core packages like OpenVPN, SSH erver etc.
2. software development packages like CMake, git, libraries etc.

You can reduce the size of the production rootfs via not installing the
development packages.
