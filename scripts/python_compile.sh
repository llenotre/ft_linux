#!/bin/bash

$PKG_SRC/configure --build "$PKG_BUILD"              \
                   --host "$PKG_HOST"                \
				   --with-sysroot="$SYSROOT"         \
				   --prefix="/usr"                   \
                   --without-ensurepip               \
				   --mandir="$SYSROOT/usr/share/man"
make
