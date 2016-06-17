#!/bin/sh

echo Updating bootloader

mount /dev/mmcblk0p1 /mnt/
cat /mnt/MLO > /dev/mtdblock0
cat /mnt/u-boot.img > /dev/mtdblock4
umount /mnt

echo Bootloader updated successfully
