#!/bin/bash

cd $PKG_SRC
make prefix=$SYSROOT/usr install
cd -
