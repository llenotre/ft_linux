#!/bin/bash

if [ "$COMPILER_STAGE" = "3" ]; then
	cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} $SYSROOT/usr/bin
fi
