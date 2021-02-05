#!/bin/bash

if [ "$COMPILER_STAGE" = "0" ]; then
	$PKG_SRC/configure --prefix="$PREFIX"        \
					   --with-sysroot="$SYSROOT" \
					   --target="$PKG_HOST"      \
					   --disable-nls             \
					   --disable-werror
elif [ "$COMPILER_STAGE" = "2" ]; then
	$PKG_SRC/configure --build "$PKG_BUILD"              \
					   --host "$PKG_HOST"                \
					   --with-sysroot="$SYSROOT"         \
					   --prefix="$SYSROOT/usr"           \
					   --mandir="$SYSROOT/usr/share/man" \
					   --enable-ld=default               \
					   --enable-plugins                  \
					   --enable-shared                   \
					   --disable-werror                  \
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
