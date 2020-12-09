#!/bin/bash

make DESTDIR="$SYSROOT" lib=lib PKGCONFIGDIR=$SYSROOT/usr/lib/pkgconfig install
