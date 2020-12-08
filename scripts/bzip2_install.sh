#!/bin/bash

cd $PKG_SRC
make PREFIX=$SYSROOT/usr install
