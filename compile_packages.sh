#!/bin/bash

get_sources() {
	mkdir -p pkg_sources
	cd pkg_sources
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
	if ! stat pkg_builds >/dev/null 2>&1; then
		mkdir -p pkg_builds
		cd pkg_sources
		ls -1 | while read file; do
			echo "Extracting $file";
			tar xvf "$file" -C ../pkg_builds >/dev/null 2>&1;
			unzip "$file" -C ../pkg_builds >/dev/null 2>&1;
		done
		cd ..
	fi
}

compile_sources() {
	mkdir -p pkg_out
	cd pkg_builds
	ls -1 | while read file; do
		echo "Compiling $file";
		cd $file
		./configure --prefix ../pkg_out
		make
		cd ..
	done
	cd ..
}

get_sources
extract_sources
compile_sources
