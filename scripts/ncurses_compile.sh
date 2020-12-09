#!/bin/bash

$PKG_SRC/configure --prefix=/usr         \
            --host="$PKG_HOST"           \
            --build="$PKG_BUILD"         \
            --mandir="/usr/share/man"    \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --enable-widec
make -C $PKG_SRC/include
make -C $PKG_SRC/progs tic
make
