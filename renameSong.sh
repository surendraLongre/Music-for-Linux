#!/bin/bash

#write script to rename the songs The same as their title name

music_dir='/media/kgpk/Music/'

while read line; do
	title_name="$(exiftool -title "$music_dir$line" | cut -d ':' -f2 | sed 's/^ //')"
	if [ -z "$title_name" ];
	then
		continue
	fi
	ext="${line##*.}"
	file_name="$title_name.$ext"
	if [ "$file_name" = "$line" ];
	then
		continue;
	fi
	mv "$music_dir$line" "$music_dir$file_name"
#	echo "$file_name"
#done <<< "$(ls $music_dir | xargs -I {} echo '{}')" 
done < <(ls $music_dir)
exit 0
