#!/bin/bash

#write script to output files with particular genre

music_dir='/media/kgpk/Music/'

while read line; do
	genre_type="$(exiftool -genre "$line" | grep -i "$1" )"
	if [ -z "$genre_type" ];
	then
		continue
	fi
	echo "$line"
 #	echo "$file_name"
done < <(ls $music_dir) 
