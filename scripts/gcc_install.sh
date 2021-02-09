#!/bin/bash

if [ "$COMPILER_STAGE" = "0" ]; then
	make install
	cat $PKG_SRC/gcc/limitx.h $PKG_SRC/gcc/glimits.h $PKG_SRC/gcc/limity.h > \
		`dirname $($SYSROOT/tools/bin/x86_64-lfs-linux-gnu-g++ -print-libgcc-file-name)`/install-tools/include/limits.h
elif [ "$COMPILER_STAGE" = "1" ]; then
	cd libstdcpp_build
	make DESTDIR="$SYSROOT" install
	cd ..
elif [ "$COMPILER_STAGE" = "3" ]; then
	cd libstdcpp_build
	make install
	cd ..
else
	make DESTDIR="$SYSROOT" install
fi

ln -sv gcc $SYSROOT/usr/bin/cc
