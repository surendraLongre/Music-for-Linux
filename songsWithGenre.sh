#!/bin/bash

#write script to output files with particular genre

music_dir="$SONGDIR"

while read line; do
	genre_type="$(exiftool -genre "$music_dir$line" | grep -i "$1" )"
	if [ -z "$genre_type" ];
	then
		continue
	fi
	echo "$line"
 #	echo "$file_name"
done < <(ls $music_dir) 
