#!/bin/bash

check_smart_boy() {
	name=$1

	count=$(ls -1 | wc -l)
	if [ $count -gt 1 ]; then
		echo "Congrats $name, you're a freaking moron who doesn't know how to make a proper tarball"
	else
		unique_file_name=$(ls -1)
		cd $unique_file_name 2>/dev/null && {
			mv * ..;
			cd ..;
			rm -rf $unique_file_name;
		}
	fi
}

get_sources() {
	mkdir -p pkg_tarballs
	mkdir -p pkg_sources

	cat source_urls | while read pkg; do
		name=`echo $pkg | cut -d ' ' -f 1`
		url=`echo $pkg | cut -d ' ' -f 2`
		checksum=`echo $pkg | cut -d ' ' -f 3`

		output=pkg_tarballs/${name}.compressed

		if ! stat $output >/dev/null 2>&1; then
			echo "Downloading $name (url: $url checksum: $checksum)"
			wget -O "$output" "$url"

			echo $checksum >/tmp/ft_linux_checksum0
			md5sum "$output" | cut -d ' ' -f 1 >/tmp/ft_linux_checksum1
			diff /tmp/ft_linux_checksum0 /tmp/ft_linux_checksum1 || {
				echo "Checksum for $name doesn't match";
				rm $output;
				exit 1;
			}
		fi

		if ! stat pkg_sources/$name >/dev/null 2>&1; then
			echo "Extracting $output";

			cd pkg_sources
			mkdir -p $name
			cd $name

			tar xvf ../../"$output" >/dev/null;
			check_smart_boy $name

			cd ../..
		fi
	done
}

compile_package() {
	if [ ! -z "$1" ] && ! grep "^${1}$" -- ../compiled >/dev/null 2>&1; then
		echo "Compiling $1";

		IFS="\n"
		grep "^$1 " -- ../deps | tr ' ' "\n" | while read dep; do
			if [ "$dep" != "$1" ]; then
				echo "$1 requires $dep"
				compile_package $dep || exit 1
			fi
		done
		IFS=""

		mkdir -p $1
		cd $1

		export PKG_SRC="../../pkg_sources/$1/"
		export PKG_BUILD="x86_64-pc-linux-gnu"
		export PKG_HOST="x86_64-pc-linux-gnu"

		compile_script_path=../../scripts/${1}_compile.sh
		if ! stat $compile_script_path >/dev/null 2>&1; then
			compile_script_path=../../scripts/__default_compile.sh
		fi

		#$compile_script_path || {
		#	echo "Compilation of $1 failed"
		#	exit 1
		#}

		install_script_path=../../scripts/${1}_install.sh
		if ! stat $install_script_path >/dev/null 2>&1; then
			install_script_path=../../scripts/__default_install.sh
		fi

		#$install_script_path || {
		#	echo "Installation of $1 failed"
		#	exit 1
		#}

		cd ..
		echo $1 >>../compiled
	fi
}

compile_sources() {
	touch compiled
	mkdir -p pkg_builds
	cd pkg_builds

	initramfs_path="$(cd ../; echo $(pwd)/initramfs/)"

	#export CFLAGS="--sysroot=$initramfs_path"
	#export CXXFLAGS="--sysroot=$initramfs_path"
	#export LDFLAGS="--sysroot=$initramfs_path"
	export SYSROOT="$initramfs_path"
	export MAKEFLAGS='-j8'

	IFS=""
	pkg_list=$(ls -1 ../pkg_sources)
	echo $pkg_list | while read file; do
		compile_package $file || exit 1;
	done
	unset IFS

	cd ..
}

get_sources
compile_sources
