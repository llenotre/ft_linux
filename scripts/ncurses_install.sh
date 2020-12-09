#!/bin/bash

make DESTDIR=$SYSROOT TIC_PATH=$(pwd)/build/progs/tic install
