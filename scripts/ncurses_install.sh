#!/bin/bash

make DESTDIR=$SYSROOT TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $SYSROOT/usr/lib/libncurses.so
