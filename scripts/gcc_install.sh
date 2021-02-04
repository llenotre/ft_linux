#!/bin/bash

if [ "$COMPILER_STAGE" != "1" ]; then
	cd libstdcpp_build
	make DESTDIR="$SYSROOT" install
	cd ..
else
	make DESTDIR="$SYSROOT" install
fi
