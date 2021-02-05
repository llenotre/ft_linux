#!/bin/bash

if [ "$COMPILER_STAGE" = "0" ]; then
	make install
	cat $PKG_SRC/gcc/limitx.h $PKG_SRC/gcc/glimits.h $PKG_SRC/gcc/limity.h > \
		`dirname $($PREFIX/bin/x86_64-lfs-linux-gnu-g++ -print-libgcc-file-name)`/install-tools/include/limits.h
elif [ "$COMPILER_STAGE" = "1" ]; then
	cd libstdcpp_build
	make DESTDIR="$PREFIX" install
	cd ..
else
	make DESTDIR="$SYSROOT" install
fi
