# ft_linux

Simple Linux distribution built from scratch.



## Installation

### Partitions layout

The partitions that must be present are the following:

- /dev/sda1: /boot
- /dev/sda2: swap parition
- /dev/sda3: /

- /dev/sr0: installation disk



### Building stages

The creation of the system is done in several stages:

- 0: Creation of an initramfs allowing to run bash with utilities to creates partitions and filesystems and mount them
- 1: Creation of a temporary system on the host machine's disk. This systems contains all utilities necessary to build the full system and should be copied to the root of the host machine's disk before being used.
- 2: Creation of the full system working on the host machine



### Paritions mounting order

- mount /dev/sda3 /mnt
- mount /dev/sda1 /mnt/boot
- mount /dev/sr0 /install
