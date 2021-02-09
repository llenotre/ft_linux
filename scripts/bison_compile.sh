#!/bin/bash

if [ "$COMPILER_STAGE" = "3" ]; then
	$PKG_SRC/configure	--prefix=/usr                       \
						--docdir=/usr/share/doc/bison-3.7.4
fi

make
