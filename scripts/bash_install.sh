#!/bin/bash

make DESTDIR=$SYSROOT install

cd $SYSROOT/usr/bin
ln -s bash sh
cd -
