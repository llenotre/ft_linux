#!/bin/bash

if [ "$COMPILER_STAGE" != "2" ]; then
	make DESTDIR="$SYSROOT" install
fi

if [ "$COMPILER_STAGE" != "1" ]; then
	cd libstdcpp_build
	make DESTDIR="$SYSROOT" install
	cd ..
fi
