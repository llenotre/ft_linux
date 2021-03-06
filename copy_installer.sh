#!/bin/bash

mkdir -p iso/install/installer

cp -r linux-4.19.157.tar.xz iso/install/
cp -r tmp_scripts/* iso/install/

cp -r scripts iso/install/installer
cp -r pkg_tarballs iso/install/installer
cp -r kernel_src iso/install/installer

cp compile_packages.sh iso/install/installer
cp get_sources.sh iso/install/installer

cp source_urls iso/install/installer
cp deps iso/install/installer
