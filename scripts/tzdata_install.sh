#!/bin/bash

ZONEINFO=$SYSROOT/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${PKG_SRC}/${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${PKG_SRC}/${tz}
    zic -L ${PKG_SRC}/leapseconds -d $ZONEINFO/right ${PKG_SRC}/${tz}
done

# TODO Symbolic link to tmp timezone on /etc/localtime

