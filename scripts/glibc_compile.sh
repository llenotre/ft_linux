#!/bin/bash

if [ "$COMPILER_STAGE" = "0" ]; then
	$PKG_SRC/configure                          \
			--prefix=/usr                       \
			--host=$PKG_HOST                    \
			--build=$PKG_BUILD                  \
			--enable-kernel=3.2                 \
			--with-headers=$SYSROOT/usr/include \
			libc_cv_slibdir=/lib
else
	$PKG_SRC/configure --prefix=/usr                   \
                       --disable-werror                \
                       --enable-kernel=3.2             \
                       --enable-stack-protector=strong \
                       --with-headers=/usr/include     \
                       libc_cv_slibdir=/lib
fi
make
