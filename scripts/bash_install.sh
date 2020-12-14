#!/bin/bash

make DESTDIR=$SYSROOT install

cd $SYSROOT/usr/bin
ln -rs bash sh
cd -
