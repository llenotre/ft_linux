#!/bin/bash

chroot /mnt /usr/bin/env -i           \
                         HOME="/root" \
                         TERM="$TERM" \
                         PATH="$PATH" \
                         /bin/bash --login +h
