#!/bin/bash

$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST --prefix="$SYSROOT/usr" \
	--with-tcl="$SYSROOT/usr/lib" \
	--with-tclinclude="$SYSROOT/usr/include" \
	--mandir="$SYSROOT/usr/share/man" \
	--enable-shared
make
make test
