#!/bin/bash

cd $PKG_SRC
./config --with-sysroot="$SYSROOT" \
         --prefix="/usr"           \
         --openssldir="/etc/ssl"   \
         --libdir=lib              \
         shared                    \
         zlib-dynamic
make
