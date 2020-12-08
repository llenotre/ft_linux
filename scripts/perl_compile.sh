#!/bin/bash
 
export BUILD_ZLIB=False
export BUILD_BZIP2=0

cd $PKG_SRC
sh Configure                                             \
	-Dprefix=$SYSROOT/usr                                \
    -Dvendorprefix=$SYSROOT/usr                          \
    -Dprivlib=$SYSROOT/usr/lib/perl5/5.32/core_perl      \
    -Darchlib=$SYSROOT/usr/lib/perl5/5.32/core_perl      \
    -Dsitelib=$SYSROOT/usr/lib/perl5/5.32/site_perl      \
    -Dsitearch=$SYSROOT/usr/lib/perl5/5.32/site_perl     \
    -Dvendorlib=$SYSROOT/usr/lib/perl5/5.32/vendor_perl  \
    -Dvendorarch=$SYSROOT/usr/lib/perl5/5.32/vendor_perl \
    -Dman1dir=$SYSROOT/usr/share/man/man1                \
    -Dman3dir=$SYSROOT/usr/share/man/man3                \
    -Dpager="$SYSROOT/usr/bin/less -isR"                 \
    -Duseshrplib                                         \
    -Dusethreads 0</dev/tty 1>/dev/tty
make
