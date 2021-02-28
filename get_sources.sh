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
			mv .* ..; # TODO Exclude `.` and `..`
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
			wget --no-check-certificate -O "$output" "$url"

			echo $checksum >/tmp/ft_linux_checksum0
			md5sum "$output" | cut -d ' ' -f 1 >/tmp/ft_linux_checksum1
			diff /tmp/ft_linux_checksum0 /tmp/ft_linux_checksum1 || {
				echo "Checksum for $name doesn't match";
				rm $output;
				exit 1
			}
		fi

		if ! stat pkg_sources/$name >/dev/null 2>&1; then
			echo "Extracting $output";

			cd pkg_sources
			mkdir -p $name
			cd $name

			tar xf ../../"$output" >/dev/null;
			check_smart_boy $name

			cd ../..
		fi
	done
}

get_sources
