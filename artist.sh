#!/bin/bash

#write script to make if they don't include any genre

music_dir="$SONGDIR"
count=0

while read line; do
	count=$((count+1))
	genre_type="$(exiftool -artist "$music_dir$line" )"
	if [ -z "$genre_type" ];
	then
		echo "$line"
	fi
#	echo "$line"
 #	echo "$file_name"
#done <<< "$(ls $music_dir | xargs -I {} echo '{}')" 
done < <(ls $music_dir) 
echo "checked $count songs"
exit 0
