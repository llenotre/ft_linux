#!/bin/bash

if [ "$COMPILER_STAGE" = "3" ]; then
	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
				--docdir=/usr/share/doc/util-linux-2.36 \
				--disable-chfn-chsh  \
				--disable-login      \
				--disable-nologin    \
				--disable-su         \
				--disable-setpriv    \
				--disable-runuser    \
				--disable-pylibmount \
				--disable-static     \
				--without-python
else
	$PKG_SRC/configure --build "$PKG_BUILD"              \
					   --host "$PKG_HOST"                \
					   --with-sysroot="$SYSROOT"         \
					   --prefix="/usr"                   \
					   --mandir="/usr/share/man"
fi

make
