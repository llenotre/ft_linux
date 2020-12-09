#!/bin/bash

make DESTDIR="$SYSROOT" install
make DESTDIR="$SYSROOT" install-private-headers
