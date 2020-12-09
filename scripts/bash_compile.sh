#!/bin/bash

$PKG_SRC/configure --prefix="/usr" \
            --build=$PKG_BUILD     \
            --host=$PKG_HOST       \
            --without-bash-malloc
make
