#!/bin/bash

cd $PKG_SRC
sed -i '/install -m.*STA/d' libcap/Makefile
make lib=lib
