#!/bin/bash

make DESTDIR="$SYSROOT" install prefix="$SYSROOT/usr/share/man"
