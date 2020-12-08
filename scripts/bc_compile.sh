#!/bin/bash

cd $PKG_SRC
PREFIX=$SYSROOT/usr CC="gcc" CFLAGS="-std=c99" ./configure.sh -G -O3
make
