set +h
umask 022

export LC_ALL=POSIX
export PKG_BUILD="x86_64-pc-linux-gnu"
export PKG_HOST="x86_64-lfs-linux-gnu"
export PATH=/usr/bin

if [ ! -L /bin ]; then
	PATH=/bin:$PATH;
fi

export PATH=$SYSROOT/tools/bin:$PATH
