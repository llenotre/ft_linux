#!/bin/bash

$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST\
	--prefix=$SYSROOT/usr\
	--with-sysroot=$SYSROOT\
	CFLAGS="-O3"
make
