#!/bin/bash

get_sources() {
	mkdir -p sources
	cd sources
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
	cd sources
	ls -1 | while read file; do
		echo "Extracting $file";
		tar xvf "$file";
	done
	cd ..
}

#compile_sources() {
	# TODO
#}

get_sources
#extract_sources
#compile_sources()
