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
	mkdir -p $1/{etc,proc,sys,mnt}
	mkdir -p $1/{usr/bin,usr/share,usr/lib,usr/local,usr/include}

	cd "$1"
	ln -rs usr/bin bin
	ln -rs usr/sbin sbin
	ln -rs usr/lib lib
	ln -rs usr/lib lib64
	cd -

	cd "$1/usr"
	ln -rs lib lib64
	cd -

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

		export PKG_SRC="../../pkg_sources/$1/"

		compile_logs_path=$logs_dir/$1_compile.log
		install_logs_path=$logs_dir/$1_install.log

		if ! grep "^${1}$" -- $compiled_file >/dev/null 2>&1; then
			print_tabs $2
			echo "Compiling $1";
			compile_script_path=$scripts_dir/${1}_compile.sh
			if ! stat $compile_script_path >/dev/null 2>&1; then
				compile_script_path=$scripts_dir/__default_compile.sh
			fi
			$compile_script_path >$compile_logs_path 2>&1 || {
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
			$install_script_path >$install_logs_path 2>&1 || {
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
	touch compiled
	touch installed
	mkdir -p logs
	mkdir -p pkg_builds
	cd pkg_builds

	export PKG_BUILD="x86_64-pc-linux-gnu"
	export PKG_HOST="x86_64-pc-linux-gnu"
	export MAKEFLAGS='-j8'

	echo "----------------------------------"
	echo "   Preparing stage $1 system..."
	echo "----------------------------------"
	echo
	if [ "$1" = "0" ]; then
		export SYSROOT="$pwd/initramfs/"
		export PKG_TMP="true"
		rm -rf $SYSROOT
		mkdir -p $SYSROOT
		prepare "$SYSROOT"

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
	elif [ "$1" = "1" ]; then
		export SYSROOT="$pwd/iso/install/"
		export PKG_TMP="true"
		rm -rf $SYSROOT
		mkdir -p $SYSROOT
		prepare "$SYSROOT"

		compile_package "m4" "0" "true" || abort
		compile_package "ncurses" "0" "true" || abort
		compile_package "bash" "0" "true" || abort
		compile_package "coreutils" "0" "true" || abort
		compile_package "diffutils" "0" "true" || abort
		compile_package "file" "0" "true" || abort
		compile_package "findutils" "0" "true" || abort
		compile_package "gawk" "0" "true" || abort
		compile_package "grep" "0" "true" || abort
		compile_package "gzip" "0" "true" || abort
		compile_package "make" "0" "true" || abort
		compile_package "patch" "0" "true" || abort
		compile_package "sed" "0" "true" || abort
		compile_package "tar" "0" "true" || abort
		compile_package "xz" "0" "true" || abort
		compile_package "binutils" "0" "true" || abort
		compile_package "gcc" "0" "true" || abort
	else
		export SYSROOT="/"
		export PKG_TMP="false"
		prepare "$SYSROOT"

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
compiled_file=$pwd/compiled
installed_file=$pwd/installed
build_system $1
