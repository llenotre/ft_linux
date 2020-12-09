#!/bin/bash

$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST \
	--prefix="/usr" \
	--disable-multilib \
	--without-isl \
	--with-sysroot="$SYSROOT"
make
