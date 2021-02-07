#!/bin/bash

cat > $SYSROOT/etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

make DESTDIR="$SYSROOT" install

if [ "$COMPILER_STAGE" = "0" ]; then # Cross compiler
	$SYSROOT/tools/libexec/gcc/$PKG_HOST/10.2.0/install-tools/mkheaders
else
	#cp -v ../nscd/nscd.conf $SYSROOT/etc/nscd.conf
	#mkdir -pv $SYSROOT/var/cache/nscd
	#
	#make localedata
	#make install-locales

	cat > $SYSROOT/etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

fi
