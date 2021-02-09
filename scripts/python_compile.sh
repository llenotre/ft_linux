#!/bin/bash

if [ "$COMPILER_STAGE" = "3" ]; then
	./configure --prefix=/usr   \
				--enable-shared \
				--without-ensurepip
else
	$PKG_SRC/configure --build "$PKG_BUILD"              \
					   --host "$PKG_HOST"                \
					   --with-sysroot="$SYSROOT"         \
					   --prefix="/usr"                   \
					   --without-ensurepip               \
					   --mandir="/usr/share/man"
fi

make
