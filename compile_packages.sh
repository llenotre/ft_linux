#!/bin/bash

get_tarballs() {
	mkdir -p pkg_tarballs
	cd pkg_tarballs
	cat ../source_urls | while read file; do
		output=${file##*/}
		if ! stat $output >/dev/null 2>&1; then
			echo "Downloading $file";
			curl "$file" --output "$output";
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
			tar xvf ../pkg_tarballs/"$file" >/dev/null 2>&1;
			unzip ../pkg_tarballs/"$file" >/dev/null 2>&1;
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
		../../pkg_sources/$file/configure
		make
		cd ..
	done
	cd ..
}

get_tarballs
extract_sources
compile_sources
