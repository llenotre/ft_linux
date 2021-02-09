#!/bin/bash

if [ "$COMPILER_STAGE" = "3" ]; then
	$PKG_SRC/configure --disable-shared
fi

make
