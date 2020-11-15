#!/bin/bash

if [ ! stat kernel_src ]; then
	wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.157.tar.xz
	mv linux-4.19.157.tar.xz kernel_src
fi
