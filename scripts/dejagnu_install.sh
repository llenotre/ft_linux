#!/bin/bash

make install
install -v -dm755  $SYSROOT/usr/share/doc/dejagnu
install -v -m644   doc/dejagnu.{html,txt} $SYSROOT/usr/share/doc/dejagnu

make check
