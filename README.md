OnRISC Debian Image Creator
===========================

Overview
--------

OnRISC Debian Image Creator is a set of bash scripts, that help to produce
a custom Debian image using debootstrap and QEMU. The scripts provide basic
packages and configuration files and can be modified in order to add
additional Debian packages, configuration files etc.

Dependencies
------------

deboostrap needs QEMU for the second stage, i.e. execute commands as
if being on the real ARM hardware. Execute following command:

`apt-get install qemu-system-arm qemu-user-static`

build.sh
--------

`build.sh` is the main script, that must be run first. It creates a rootfs
folder specified in `DROOTFS` variable. You can change `DROOTFS` to `/mnt`,
i.e. mount folder where you've mounted the second partition of your SD card.
This would create Debian image directly on the SD card.

After creating the rootfs folder `build.sh` invokes debootstrap's first
stage, that creates basic root file system. Then `vsdeb.sh` and QEMU will
be copied to the newly created rootfs and executed via `chroot`.

`vsdebootstrap` provides following folder infrastructure in oder to manage
custom configuration files and packages:

* `fs-overlay` - this folder holds custom configuration files and it has
the same folder structure as root file systems. I.e. if you want to provide
your own `sshd_config`, you must create following folders in fs-overlay:
`etc/ssh/` and place `ssh_config` there
* `packages` - this folder holds *.deb files. If this folde is empty,
`build.sh` will download our standard packages like kerenel.deb, libonrisc.deb
etc. The packages will be then copied to the target root file system and
installed

You can extend or overwrite files/packages via `.vs_external` file. Just put
path to the folder, that provides the same structure, i.e. `fs-overlay` and
`packages` folders. Put your files/packages into these folders. These folders
will be handled at the end, so its contant would overwrite local files.

vsdeb.sh
--------

`vsdeb.sh` will be executed in the virtual machine. This script installs
additional Debian packages, creates root password etc.

So far additional packages are divided into multiple categories like *core*,
*network*, *firmware* etc.

You can reduce the size of the production rootfs via commenting/modifying
related `apt-get` invocations.
