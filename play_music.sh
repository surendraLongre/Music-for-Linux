#!/bin/bash
#script to play the music

#writing music directory

music_path="/home/kgpk/my_scripts/music_script/songs_link.txt"	# music text file to play songs from a url

#get the song name
# add the stop-music option to stop mpv player

if [ -z "$1" ]; # if the user don't provide appropriate command line options
then
	echo "usage: playmusic <song_name>	//to play the song, or"
	echo "usage: playmusic stop-music 	//to stop the music"
	exit 1
	#
	# play songs in order
	#

elif [ "$1" = "--all" ];
then
	while read -r line; do
		link_addr="$(echo $line | awk '{print $NF}')"
		song_name="$(echo $line | cut -d'-' -f1)"
		if [[ -z $link_addr ]];
		then
			echo "song not found"
			exit 2
		else
			mpv $link_addr --no-video &>/dev/null &
			echo "playing $song_name"
			wait
		fi
	done < "$music_path"
	exit 0

#
# play songs as shuffle
#

elif [ "$1" = "--shuffle" ];
then
	song_index=1
	shuffled_music=$(shuf "$music_path")
	while read -r line; do
		link_addr="$(echo $line | awk '{print $NF}')"
		song_name="$(echo $line | cut -d'-' -f1)"
		if [[ -z $link_addr ]];
		then
			echo "song not found"
			exit 2
		else
			mpv $link_addr --no-video &>/dev/null &
			echo "playing $song_index $song_name"
			wait
			song_index=$((song_index+1))
		fi
	done <<< "$shuffled_music"
	exit 0

#
# stop music on users request
#

elif [ "$1" = "stop-music" ];
then
	music_pid="$(ps -ef | grep mpv | grep '\--loop --no-video' | awk '{print $2}')"
	if [ -z "$music_pid" ]; then
		echo 'no music is being played'
		exit 1
	fi
	kill $music_pid
	exit 0

elif [ "$1" = "genre" ];
then
		music_pid="$(ps -ef | grep mpv | grep '\--loop --no-video' | awk '{print $2}')"
		#check if music is already being played
		#if so stop the current song and play the requested one
		if [ -n "$music_pid" ]; then
			kill $music_pid
		fi #finish with the stopping function for already playing songs
	echo "$1 $2"
	music_dir='/media/kgpk/Music/'
	while read -r line; do
		trap 'exit 1' SIGINT  # Trap SIGINT signal and exit with status 1
		dir="/media/kgpk/Music/$line"
		loop_genre="$(exiftool -genre "$dir" | grep -i $2)"
		#		echo $loop_genre
		if [[ -z $loop_genre ]];
		then
			continue
		else
			mpv "$dir" --no-video
			#wait
		fi
	done < <(ls $music_dir | shuf )
	exit 0
fi

#
# play songs from url
# get the url links and check whether it exists or not or play the music
#

song_name=$1
music_dir='/media/kgpk/Music/' 		# local songs directory

link_addr="$(grep -i "$song_name" < <(ls $music_dir))"
if [ "$(echo "$link_addr" | wc -l)" -gt 1 ]; then
	echo "######################################## matched songs ########################################"
	#echo "currently matched songs, play by additional keywords"																
	echo "$link_addr"
	echo "###############################################################################################"
	echo
fi
link_addr="$(grep -i "$song_name" < <(ls $music_dir) | head -1)"

if [ -z "$link_addr" ]; then
	echo empty
	link_addr="$(grep -i "$song_name" "$music_path" | awk '{print $NF}')"
else
	song_name="$link_addr"
	link_addr="$music_dir$link_addr"
fi

if [[ -z $link_addr ]];
then
	#search for the song on youtube
	#and get the link to the song
	search_result=$(curl -s "https://www.youtube.com/results?search_query=$(echo "$@" | tr ' ' '+' )" | awk '{ match($0, /videoId(.{22})/, arr); print arr[1] }' | sed '/^$/d' | cut -c4-14)
	#echo $search_result
	link_addr="https://www.youtube.com/watch?v=$search_result"

	music_pid="$(ps -ef | grep mpv | grep '\--loop --no-video' | awk '{print $2}')"
	#check if music is already being played
	#if so stop the current song and play the requested one
	if [ -n "$music_pid" ]; then
		kill $music_pid
	fi
	mpv "$link_addr" --loop --no-video #&>/dev/null &
	echo "playing '$@'"
	exit 0
else
	if [ -z "$2" ]; then
		music_pid="$(ps -ef | grep mpv | grep '\--loop --no-video' | awk '{print $2}')"
		#check if music is already being played
		#if so stop the current song and play the requested one
		if [ -n "$music_pid" ]; then
			kill $music_pid
		fi
		mpv "$link_addr" --loop --no-video &>/dev/null &
		echo "playing '$song_name'"
	else
		index=0
		while read -r line; do
			link_addr="$(echo $line | awk '{print $NF}')"
			song_name="$(echo $line | cut -d'-' -f1)"
			if [ $index = 0 ]; then
				shopt -s nocasematch
				if [[ $song_name =~ "$1" ]]; then
					index=1
				else
					#			echo $song_name
					continue
				fi

			fi

			if [[ -z $link_addr ]];
			then
				echo "song not found"
				exit 1
			else
				mpv $link_addr --no-video &>/dev/null &
				echo "playing $song_name"
				wait
			fi
		done < "$music_path"
		exit 0
	fi

fi

