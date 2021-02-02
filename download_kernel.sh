#!/bin/bash

if ! [ -z "$KERNEL_DIR" ]; then
	cd $KERNEL_DIR
fi

dir=linux-4.19.157
tarname=$dir.tar.xz

if ! stat $tarname >/dev/null 2>&1; then
	wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.157.tar.xz
fi

if ! stat kernel_src >/dev/null 2>&1; then
	tar xvf $tarname
	mv $dir kernel_src
fi
