#!/bin/bash

$PKG_SRC/configure --prefix=/usr                    \
            --host=$PKG_HOST                        \
            --build=$PKG_BUILD                      \
            --enable-install-program=hostname       \
            --enable-no-install-program=kill,uptime
make
