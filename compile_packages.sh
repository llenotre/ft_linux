#!/bin/bash

get_tarballs() {
	mkdir -p pkg_tarballs
	cd pkg_tarballs
	cat ../source_urls | while read pkg; do
		checksum=`echo $pkg | cut -d ' ' -f 2`
		url=`echo $pkg | cut -d ' ' -f 1`
		output=${url##*/}
		if ! stat $output >/dev/null 2>&1; then
			echo "Downloading $output (url: $url checksum: $checksum)"
			wget -O "$output" "$url"

			echo $checksum >/tmp/ft_linux_checksum0
			md5sum "$output" | cut -d ' ' -f 1 >/tmp/ft_linux_checksum1
			diff /tmp/ft_linux_checksum0 /tmp/ft_linux_checksum1 || {
				echo "Checksum doesn't correspond!";
				rm $output;
				exit;
			}
		fi
	done
	cd ..
}

extract_sources() {
	if ! stat pkg_sources >/dev/null 2>&1; then
		mkdir -p pkg_sources
		cd pkg_sources
		ls -1 ../pkg_tarballs | while read file; do
			echo "Extracting $file";
			tar xvf ../pkg_tarballs/"$file" >/dev/null;
		done
		cd ..
	fi
}

compile_package() {
	name=$1
	stage=$2

	initramfs_path="$(cd ../; echo $(pwd)/initramfs/)"

	echo "Compiling $name";
	mkdir $name
	cd $name

	if [ $stage = 0 ]; then
		../../pkg_sources/$name/configure --with--sysroot=$initramfs_path --prefix=$initramfs_path  --host x86_64-pc-linux-gnu
	else
		CFLAGS="--sysroot=$initramfs" ../../pkg_sources/$name/configure --with-sysroot=$initramfs --with-build-sysroot=$initramfs --prefix=$initramfs --host x86_64-pc-linux-gnu
	fi || {
		echo "Configuration of $initramfs_path failed"
		exit 1
	}

	make && make install || {
		echo "Compilation of $initramfs_path failed"
		exit 1
	}

	cd ..
}

compile_sources() {
	mkdir -p pkg_builds
	cd pkg_builds

	compile_package $(ls -1 ../pkg_sources | grep ^glibc-) 0
	compile_package $(ls -1 ../pkg_sources | grep ^gmp-) 0
	compile_package $(ls -1 ../pkg_sources | grep ^mpfr-) 0
	compile_package $(ls -1 ../pkg_sources | grep ^mpc-) 0
	compile_package $(ls -1 ../pkg_sources | grep ^gcc-) 1

	#pkg_list=$(ls -1 ../pkg_sources | grep -v ^glibc- | grep -v ^gcc-)
	#echo $pkg_list | while read file; do
	#	compile_package $file
	#done
	cd ..
}

get_tarballs
extract_sources
compile_sources
