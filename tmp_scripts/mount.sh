#!/bin/bash

mount /dev/sda3 /mnt
mount /dev/sda1 /mnt/boot
mount /dev/sr0 /install

mkdir -p /mnt/dev
cp -r /dev/* /mnt/dev

mkdir -p /mnt/proc /mnt/sys /mnt/tmp
mount -vt proc proc /mnt/proc
mount -vt sysfs sysfs /mnt/sys
mount -vt tmpfs tmpfs /mnt/tmp
