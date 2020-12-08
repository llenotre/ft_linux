#!/bin/bash

cd $PKG_SRC
sed -r -i '/^char.*parseopt_program_(doc|args)/d' src/parseopt.c
cd -

$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST --prefix="$SYSROOT/usr" --mandir="$SYSROOT/usr/share/man"\
	--disable-static \
	--enable-libgdbm-compat
make
