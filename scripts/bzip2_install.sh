#!/bin/bash

cd $PKG_SRC
make DESTDIR="$SYSROOT" PREFIX=$SYSROOT/usr install
