#!/bin/bash

get_tarballs() {
	mkdir -p pkg_tarballs
	cd pkg_tarballs
	cat ../source_urls | while read pkg; do
		checksum=${pkg##* }
		url=${pkg## *}
		output=${url##*/}
		if ! stat $output >/dev/null 2>&1; then
			echo "Downloading $output (checksum: $checksum)";
			curl "$url" --output "$output";

			echo $checksum >/tmp/ft_linux_checksum0;
			md5sum "$file" >/tmp/ft_linux_checksum1 | cut -d ' ' -f 1;
			diff /tmp/ft_linux_checksum0 /tmp/ft_linux_checksum1;
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
			tar zxvf ../pkg_tarballs/"$file" >/dev/null;
		done
		cd ..
	fi
}

compile_sources() {
	mkdir -p pkg_builds
	cd pkg_builds
	ls -1 ../pkg_sources | while read file; do
		echo "Compiling $file";
		mkdir $file
		cd $file
		../../pkg_sources/$file/configure --prefix=/
		make
		cd ..
	done
	cd ..
}

get_tarballs
extract_sources
compile_sources
