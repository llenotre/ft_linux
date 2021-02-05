#!/bin/bash

if [ "$COMPILER_STAGE" != "1" ]; then
	cd libstdcpp_build
	make DESTDIR="$PREFIX" install
	cd ..
else
	make DESTDIR="$SYSROOT" install
fi

if [ "$COMPILER_STAGE" != "0" ]; then
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
		`dirname $(x86_64-pc-linux-gnu-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
fi
