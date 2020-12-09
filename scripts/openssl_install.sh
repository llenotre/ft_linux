#!/bin/bash

cd $PKG_SRC

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v $SYSROOT/usr/share/doc/openssl $SYSROOT/usr/share/doc/openssl-1.1.1h
cp -vfr doc/* $SYSROOT/usr/share/doc/openssl-1.1.1h
