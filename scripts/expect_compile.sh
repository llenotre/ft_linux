#!/bin/bash

$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST --with-sysroot="$SYSROOT" --prefix="/usr" \
	--with-tcl="/usr/lib" \
	--with-tclinclude="/usr/include" \
	--mandir="/usr/share/man" \
	--enable-shared
make
make test
