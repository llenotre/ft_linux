#!/bin/bash

#if [ "$PKG_TMP" == "true" ]; then
	$PKG_SRC/configure                  \
		--target="$PKG_HOST"            \
		--prefix="/usr"                 \
		--with-glibc-version=2.11       \
		--with-sysroot="$SYSROOT"       \
		--with-build-sysroot="$SYSROOT" \
		--with-newlib                   \
		--without-headers               \
		--without-isl                   \
		--enable-initfini-array         \
		--disable-multilib              \
		#--disable-nls                   \
		#--disable-shared                \
		#--disable-decimal-float         \
		#--disable-threads               \
		#--disable-libatomic             \
		#--disable-libgomp               \
		#--disable-libquadmath           \
		#--disable-libssp                \
		#--disable-libvtv                \
		#--disable-libstdcxx             \
		--enable-languages=c,c++
#else
#	$PKG_SRC/configure --build $PKG_BUILD --host $PKG_HOST \
#		--prefix="/usr" \
#		--disable-multilib \
#		--without-isl \
#		--with-sysroot="$SYSROOT"
#fi
make
