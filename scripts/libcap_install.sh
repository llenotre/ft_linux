#!/bin/bash

cd $PKG_SRC
make DESTDIR="$SYSROOT" lib=lib PKGCONFIGDIR=$SYSROOT/usr/lib/pkgconfig install
true
