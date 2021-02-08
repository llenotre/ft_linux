#!/bin/bash

$PKG_SRC/configure --build "$PKG_BUILD"              \
                   --host "$PKG_HOST"                \
				   --with-sysroot="$SYSROOT"         \
				   --prefix="/usr"                   \
				   --without-libsigsegv-prefix       \
				   --disable-perl-regexp             \
                   --disable-nls                     \
				   --mandir="/usr/share/man"
make
