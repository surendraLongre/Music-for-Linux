#!/bin/bash

#local songs music directory
music_dir="$SONGDIR"
lyric_dir="$LYRCDIR"
fav_file="/home/kgpk/Documents/myFavSongs.txt"

#write function definitions

play(){
	mpv "$@"
}

stop(){
	music_pid="$(pidof mpv | tr ' ' '\n' )"
	if [ "$(echo "$music_pid" | wc -l)" -gt 1 ]; then
		echo "$music_pid"
		exit 1
	fi
	if [ -z "$music_pid" ]; then
		echo 'no music was being played'
		return
	fi
	kill $music_pid 
}


#function definition ends here

if [ -z "$1" ]; # if the user don't provide appropriate command line options
then
	echo "usage: play <song_name>	//to play the song, or"
	echo "usage: play stop-music 	//to stop the music"
	exit 1
	
#
# stop music on users request
#

elif [ "$1" = "stop-music" ];
then
	stop
	exit 0

elif [ "$1" = "genre" ];
then
	while read -r line; do
		trap 'exit 1' SIGINT  # Trap SIGINT signal and exit with status 1
		dir="/mnt/kgpk/Music/$line"
		loop_genre="$(exiftool -genre "$dir" | grep -i $2)"
		#		echo $loop_genre
		if [[ -z $loop_genre ]];
		then
			continue
		else
			play "$dir" --no-video ${@:3} --sub-file-paths="$lyric_dir" --sub-auto=fuzzy
			#wait
		fi
	done < <(ls $music_dir | shuf )
	exit 0

elif [ "$1" = "artist" ];
then
	while read -r line; do
		trap 'exit 1' SIGINT  # Trap SIGINT signal and exit with status 1
		dir="/mnt/kgpk/Music/$line"
		loop_genre="$(exiftool -artist "$dir" | grep -i $2)"
		#		echo $loop_genre
		if [[ -z $loop_genre ]];
		then
			continue
		else
			play "$dir" --no-video ${@:3} --sub-file-paths="$lyric_dir" --sub-auto=fuzzy
			#wait
		fi
	done < <(ls $music_dir | shuf )
	exit 0
elif [ "$1" = "fav" ];
then
	if [ -f "$2" ];
	then
		while read -r line; do
			trap 'exit 1' SIGINT  # Trap SIGINT signal and exit with status 1
			playmusic "$line" ${@:3} --sub-file-paths="$lyric_dir" --sub-auto=fuzzy
		done < <(cat $2 | shuf )
		exit 0
	fi
	while read -r line; do
		trap 'exit 1' SIGINT  # Trap SIGINT signal and exit with status 1
		playmusic "$line" ${@:2} --sub-file-paths="$lyric_dir" --sub-auto=fuzzy
	done < <(cat $fav_file | shuf )
	exit 0
fi

#play songs on user request
link_addr="$(grep -i "$1" < <(ls $music_dir))"
if [ "$(echo "$link_addr" | wc -l)" -gt 1 ]; then
	echo "######################################## matched songs ########################################"
	#echo "currently matched songs, play by additional keywords"																
	echo "$link_addr"
	echo "###############################################################################################"
	echo
#	link_addr="$(echo "$link_addr" | head -1)"
fi

#add full path to link_addr variable
if [ -n "$link_addr" ]; then
	song_name="$link_addr"

	while read -r line; do
		trap 'exit 1' SIGINT  # Trap SIGINT signal and exit with status 1
#		dir="/mnt/kgpk/Music/$line"
		echo $line
		line="$music_dir$line"
		play "$line" --no-video ${@:2} --sub-file-paths="$lyric_dir" --sub-auto=fuzzy
			#wait
	done <<< "$link_addr"
	exit 0
fi

#if no song exist in the provided link_addr variable
#search songs on youtube

if [[ -z $link_addr ]];
then
	#search for the song on youtube
	#and get the link to the song
	search_result=$(curl -s "https://www.youtube.com/results?search_query=$(echo "$1" | tr ' ' '+' )" | awk '{ match($0, /videoId(.{22})/, arr); print arr[1] }' | sed '/^$/d' | cut -c4-14)
	#echo $search_result
	link_addr="https://www.youtube.com/watch?v=$search_result"
	echo "playing online"
fi

echo playing ${song_name:-$1}
play "$link_addr" --no-video ${@:2} --sub-file-paths="$lyric_dir" --sub-auto=fuzzy
