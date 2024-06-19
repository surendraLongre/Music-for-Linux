#!/bin/bash

#write script to make if they don't include any genre

music_dir='/media/kgpk/Music/'

while read line; do
	genre_type="$(exiftool -genre "$music_dir$line" | egrep -i "romantic|sad|uplifting" )"
	if [ -z "$genre_type" ];
	then
		echo "$line"
	fi
#	echo "$line"
 #	echo "$file_name"
#done <<< "$(ls $music_dir | xargs -I {} echo '{}')" 
done < <(ls $music_dir) 
exit 0
