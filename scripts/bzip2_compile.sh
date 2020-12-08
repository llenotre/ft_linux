#!/bin/bash

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

cd $PKG_SRC
make -f Makefile-libbz2_so
make clean
make
