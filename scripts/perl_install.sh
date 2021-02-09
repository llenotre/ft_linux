#!/bin/bash

cd $PKG_SRC

if [ "$COMPILER_STAGE" = "3" ]; then
	make install
else
	make DESTDIR="$SYSROOT" install
fi
