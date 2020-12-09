#!/bin/bash

cd $PKG_SRC/unix
./configure --prefix=$SYSROOT/usr           \
            --mandir=$SYSROOT/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit)

make

sed -e "s|/unix|/usr/lib|" \
    -e "s||/usr/include|"  \
    -i tclConfig.sh

sed -e "s|/unix/pkgs/tdbc1.1.1|/usr/lib/tdbc1.1.1|" \
    -e "s|/pkgs/tdbc1.1.1/generic|/usr/include|"    \
    -e "s|/pkgs/tdbc1.1.1/library|/usr/lib/tcl8.6|" \
    -e "s|/pkgs/tdbc1.1.1|/usr/include|"            \
    -i pkgs/tdbc1.1.1/tdbcConfig.sh

sed -e "s|/unix/pkgs/itcl4.2.0|/usr/lib/itcl4.2.0|" \
    -e "s|/pkgs/itcl4.2.0/generic|/usr/include|"    \
    -e "s|/pkgs/itcl4.2.0|/usr/include|"            \
    -i pkgs/itcl4.2.0/itclConfig.sh
