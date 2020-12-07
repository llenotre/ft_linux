#!/bin/bash

$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST --prefix="$SYSROOT/usr" --mandir="$SYSROOT/usr/share/man"
make
