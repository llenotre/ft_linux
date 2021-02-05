#!/bin/bash

mkdir -p libstdcpp_build

pushd $PKG_SRC
./contrib/download_prerequisites
popd

export CXXCPP=/usr/bin/cpp

if [ "$COMPILER_STAGE" = "0" ]; then # Cross compiler
	$PKG_SRC/configure            \
		--target="$PKG_HOST"      \
		--prefix=$PREFIX          \
		--with-glibc-version=2.11 \
		--with-sysroot=$SYSROOT   \
		--with-newlib             \
		--without-headers         \
		--enable-initfini-array   \
		--disable-nls             \
		--disable-shared          \
		--disable-multilib        \
		--disable-decimal-float   \
		--disable-threads         \
		--disable-libatomic       \
		--disable-libgomp         \
		--disable-libquadmath     \
		--disable-libssp          \
		--disable-libvtv          \
		--disable-libstdcxx       \
		--enable-languages=c,c++
	make
elif [ "$COMPILER_STAGE" = "1" ]; then # Cross compiler'd libstdc++
	cd libstdcpp_build
	$PKG_SRC/libstdc++-v3/configure \
		--host=$PKG_HOST            \
		--build=$PKG_BUILD          \
		--prefix=/usr               \
		--disable-multilib          \
		--disable-nls               \
		--disable-libstdcxx-pch     \
		--with-gxx-include-dir=/tools/$PKG_HOST/include/c++/10.2.0
	make
	cd ..
elif [ "$COMPILER_STAGE" = "2" ]; then # Builds temporary gcc
	$PKG_SRC/configure                \
		--build=$PKG_BUILD            \
		--host=$PKG_HOST              \
		--prefix=/usr                 \
		CC_FOR_TARGET=${PKG_HOST}-gcc \
		--with-build-sysroot=$SYSROOT \
		--enable-initfini-array       \
		--disable-nls                 \
		--disable-multilib            \
		--disable-decimal-float       \
		--disable-libatomic           \
		--disable-libgomp             \
		--disable-libquadmath         \
		--disable-libssp              \
		--disable-libvtv              \
		--disable-libstdcxx           \
		--enable-languages=c,c++
	make
elif [ "$COMPILER_STAGE" = "3" ]; then # Building libstdc++ in chroot
	cd libstdcpp_build
	$PKG_SRC/libstdc++-v3/configure      \
		CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
		--prefix=/usr                    \
		--disable-multilib               \
		--disable-nls                    \
		--host=$(uname -m)-lfs-linux-gnu \
		--disable-libstdcxx-pch
	make
	cd ..
else # Final gcc
	$PKG_SRC/configure --prefix=/usr            \
				       LD=ld                    \
				       --enable-languages=c,c++ \
				       --disable-multilib       \
				       --disable-bootstrap      \
				       --with-system-zlib
	make
fi
