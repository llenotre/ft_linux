#!/bin/bash

if [ "$COMPILER_STAGE" = "0" ]; then
	$PKG_SRC/configure --prefix="$SYSROOT/tools" \
					   --with-sysroot="$SYSROOT" \
					   --target="$PKG_HOST"      \
					   --disable-nls             \
					   --disable-werror
elif [ "$COMPILER_STAGE" = "2" ]; then
	$PKG_SRC/configure --prefix="/usr"      \
					   --build="$PKG_BUILD" \
					   --host="$PKG_HOST"   \
                       --disable-nls        \
                       --enable-shared      \
                       --disable-werror     \
                       --enable-64-bit-bfd
else
	$PKG_SRC/configure --prefix=/usr       \
                       --enable-gold       \
                       --enable-ld=default \
                       --enable-plugins    \
                       --enable-shared     \
                       --disable-werror    \
                       --enable-64-bit-bfd \
                       --with-system-zlib
fi
make
