#!/bin/bash

mount -v --bind /dev/pts /mnt/dev/pts
chroot /mnt /usr/bin/env -i                                   \
                         HOME="/root"                         \
                         TERM="$TERM"                         \
						 PS1="(lfs chroot)"                   \
                         PATH="/bin:/usr/bin:/sbin:/usr/sbin" \
                         /bin/bash --login +h
