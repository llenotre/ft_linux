#!/bin/bash

#trap "exit 1" TERM
export SCRIPT_PID=$$

abort() {
	kill -s TERM -$SCRIPT_PID
	sleep 10
}

prepare() {
	rm -f $installed_file
	echo "Preparing sysroot in '$1'..."
	pushd "$1"

	mkdir -pv {etc,proc,sys,mnt,boot,root,srv,var,tmp,opt}
	mkdir -pv etc/{opt,sysconfig}
	mkdir -pv media/{floppy,cdrom}
	mkdir -pv usr/{,local/}{bin,include,lib,sbin,src}
	mkdir -pv usr/{,local/}share/{color,dict,doc,info,locale,man}
	mkdir -pv usr/{,local/}share/{misc,terminfo,zoneinfo}
	mkdir -pv usr/{,local/}share/man/man{1..8}
	mkdir -pv var/{cache,local,log,mail,opt,spool}
	mkdir -pv var/lib/{color,misc,locate}

	ln -sfv usr/bin bin
	ln -sfv usr/sbin sbin

	pushd "usr"
	ln -sfv lib lib64
	popd
	ln -sfv usr/lib lib
	ln -sfv usr/lib lib64
	mkdir -pv lib/firmware

	ln -sfv run var/run
	ln -sfv run/lock var/lock

	ln -sfv proc/self/mounts etc/mtab

	echo "127.0.0.1 localhost" >etc/hosts
	cat >etc/passwd <<"EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

	cat >etc/group <<"EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
wheel:x:97:
nogroup:x:99:
users:x:999:
EOF

	touch var/log/{btmp,lastlog,faillog,wtmp}
	popd

	make -C $kernel_src headers_install ARCH=i386 INSTALL_HDR_PATH="$1/usr"
}

print_tabs() {
	i=0
	while [ "$i" -lt "$1" ]; do
		echo -n '	'
		i=$(($i + 1))
	done
}

compile_package() {
	if [ ! -z "$1" ]; then
		if [ "$3" == "true" ]; then
			grep "^$1 " -- ../deps | tr ' ' "\n" | while read dep; do
				if [ "$dep" != "$1" ]; then
					print_tabs $2
					echo "$1 requires $dep"
					compile_package "$dep" "$(($2 + 1))" || exit 1
				fi
			done
		fi

		mkdir -p $1
		cd $1

		export PKG_SRC="$pwd/pkg_sources/$1/"

		compile_logs_path=$logs_dir/$1_compile.log
		install_logs_path=$logs_dir/$1_install.log

		if ! grep "^${1}$" -- $compiled_file >/dev/null 2>&1; then
			print_tabs $2
			echo "Compiling $1";
			compile_script_path=$scripts_dir/${1}_compile.sh
			if ! stat $compile_script_path >/dev/null 2>&1; then
				compile_script_path=$scripts_dir/__default_compile.sh
			fi
			$compile_script_path >>$compile_logs_path 2>&1 || {
				print_tabs $2
				echo "Compilation of $1 failed"
				exit 1
			}

			echo $1 >>$compiled_file
		fi

		if ! grep "^${1}$" -- $installed_file >/dev/null 2>&1; then
			print_tabs $2
			echo "Installing $1";
			install_script_path=$scripts_dir/${1}_install.sh
			if ! stat $install_script_path >/dev/null 2>&1; then
				install_script_path=$scripts_dir/__default_install.sh
			fi
			$install_script_path >>$install_logs_path 2>&1 || {
				print_tabs $2
				echo "Installation of $1 failed"
				exit 1
			}

			echo $1 >>$installed_file
		fi

		cd ..
	fi
}

build_system() {
	touch $compiled_file
	touch $installed_file
	rm -rf logs
	mkdir -p logs
	mkdir -p pkg_builds_$1
	cd pkg_builds_$1

	iso_path="$pwd/iso/install/"

	export MAKEFLAGS='-j8'

	echo "----------------------------------"
	echo "   Preparing stage $1 system..."
	echo "----------------------------------"
	echo
	if [ "$1" = "0" ]; then # Temporary system for initramfs
		export PKG_HOST=$PKG_BUILD
		export SYSROOT="$pwd/initramfs/"
		rm -rf $SYSROOT
		mkdir -p $SYSROOT
		prepare "$SYSROOT"
		mkdir -p "$SYSROOT/install/"
		cp $pwd/tmp_scripts/* "$SYSROOT"

		compile_package "glibc" "0" "false" || abort
		compile_package "readline" "0" "false" || abort
		compile_package "ncurses" "0" "false" || abort
		compile_package "bash" "0" "false" || abort
		compile_package "libcap" "0" "false" || abort
		compile_package "acl" "0" "false" || abort
		compile_package "attr" "0" "false" || abort
		compile_package "coreutils" "0" "false" || abort
		compile_package "util-linux" "0" "false"
		compile_package "e2fsprogs" "0" "false" || abort
	elif [ "$1" = "1" ]; then # Compiling cross-compiler
		export SYSROOT="$iso_path"
		export COMPILER_STAGE="0"
		mkdir -p $SYSROOT
		prepare "$SYSROOT"

		export PATH="$pwd/iso/install/tools//bin:$PATH"

		compile_package "binutils" "0" "false" || abort
		compile_package "gcc" "0" "false" || abort
		compile_package "glibc" "0" "false" || abort

		export COMPILER_STAGE="1"
		sed -i '/^gcc$/d' $compiled_file
		sed -i '/^gcc$/d' $installed_file
		compile_package "gcc" "0" "false" || abort
	elif [ "$1" = "2" ]; then # Cross-compiling temporary tools
		export SYSROOT="$iso_path"
		export COMPILER_STAGE="2"
		mkdir -p $SYSROOT

		export PATH="$pwd/iso/install/tools//bin:$PATH"

		compile_package "m4" "0" "false" || abort
		compile_package "ncurses" "0" "false" || abort
		compile_package "bash" "0" "false" || abort
		compile_package "coreutils" "0" "false" || abort
		compile_package "diffutils" "0" "false" || abort
		compile_package "file" "0" "false" || abort
		compile_package "findutils" "0" "false" || abort
		compile_package "gawk" "0" "false" || abort
		compile_package "grep" "0" "false" || abort
		compile_package "gzip" "0" "false" || abort
		compile_package "make" "0" "false" || abort
		compile_package "patch" "0" "false" || abort
		compile_package "sed" "0" "false" || abort
		compile_package "tar" "0" "false" || abort
		compile_package "xz" "0" "false" || abort
		compile_package "binutils" "0" "false" || abort
		compile_package "gcc" "0" "false" || abort
	elif [ "$1" = "3" ]; then # Compiling in chroot
		export SYSROOT="/"
		export COMPILER_STAGE="3"

		compile_package "gcc" "0" "false" || abort
		compile_package "gettext" "0" "false" || abort
		compile_package "bison" "0" "false" || abort
		compile_package "perl" "0" "false" || abort
		compile_package "python" "0" "false" || abort
		compile_package "texinfo" "0" "false" || abort
		compile_package "util-linux" "0" "false" || abort

		echo "Clearning up..."
		find /usr/{lib,libexec} -name \*.la -delete
		rm -rf /usr/share/{info,man,doc}/*
	else # Final system compilation
		export SYSROOT="/"
		export COMPILER_STAGE="4"

		IFS=""
		pkg_list=$(ls -1 ../pkg_sources)
		echo $pkg_list | while read file; do
			compile_package "$file" "0" "true" || abort
		done
		unset IFS
	fi

	echo
	echo "Done"

	cd ..
}

pwd=$(pwd)
kernel_src=$pwd/kernel_src
logs_dir=$pwd/logs
scripts_dir=$pwd/scripts
compiled_file=$pwd/compiled_$1
installed_file=$pwd/installed_$1

export PATH=/usr/bin

if [ ! -L /bin ]; then
	PATH=/bin:$PATH;
fi

export PATH=$SYSROOT/tools/bin:$PATH

export LC_ALL=POSIX
export PKG_BUILD="x86_64-pc-linux-gnu"
export PKG_HOST="x86_64-lfs-linux-gnu"

build_system $1
