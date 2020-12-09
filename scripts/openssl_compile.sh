#!/bin/bash

cd $PKG_SRC
./config --prefix=$SYSROOT/usr         \
         --openssldir=$SYSROOT/etc/ssl \
         --libdir=lib                  \
         shared                        \
         zlib-dynamic
make
