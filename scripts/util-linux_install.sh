#!/bin/bash

mkdir -pv $SYSROOT/var/lib/hwclock

make DESTDIR="$SYSROOT" install
exit 0
