#!/bin/bash
 
export BUILD_ZLIB=False
export BUILD_BZIP2=0

cd $PKG_SRC
sh Configure -des                                \
	-Dprefix=/usr                                \
    -Dvendorprefix=/usr                          \
    -Dprivlib=/usr/lib/perl5/5.32/core_perl      \
    -Darchlib=/usr/lib/perl5/5.32/core_perl      \
    -Dsitelib=/usr/lib/perl5/5.32/site_perl      \
    -Dsitearch=/usr/lib/perl5/5.32/site_perl     \
    -Dvendorlib=/usr/lib/perl5/5.32/vendor_perl  \
    -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl \
    -Dman1dir=/usr/share/man/man1                \
    -Dman3dir=/usr/share/man/man3                \
    -Dpager="/usr/bin/less -isR"                 \
    -Duseshrplib                                 \
    -Dusethreads 0</dev/tty 1>/dev/tty
make
