#!/bin/bash

$PKG_SRC/configure --with-sysroot="$SYSROOT" --prefix="/usr"
make
