#!/bin/bash

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
make
