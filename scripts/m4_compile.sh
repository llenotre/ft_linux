#!/bin/bash

cd $PKG_SRC
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
cd -

export CFLAGS="-Wabi=11"
$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST --prefix="$SYSROOT/usr" --mandir="$SYSROOT/usr/share/man"
make
