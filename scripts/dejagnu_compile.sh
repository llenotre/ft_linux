#!/bin/bash

$PKG_SRC/configure --prefix="$SYSROOT/usr"
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi
