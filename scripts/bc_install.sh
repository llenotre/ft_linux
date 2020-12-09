#!/bin/bash

cd $PKG_SRC
make DESTDIR="$SYSROOT" install
