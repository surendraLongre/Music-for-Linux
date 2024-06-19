#!/bin/bash
#script to play the music

#writing music directory

music_path="/home/kgpk/my_scripts/music_script/songs_link.txt"	# music text file to play songs from a url

#get the song name
song_name=$1

link_addr="$(grep -i "$song_name" "$music_path" | awk '{print $NF}')"
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
			exit
		else
			mpv $link_addr --no-video &>/dev/null &
			echo "playing $song_name"
			wait
		fi
	done < "$music_path"
	exit
	
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
			exit
		else
			mpv $link_addr --no-video &>/dev/null &
			echo "playing $song_index $song_name"
			wait
			song_index=$((song_index+1))
		fi
	done <<< "$shuffled_music"
	exit

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
fi

#
# play songs from url
# get the url links and check whether it exists or not or play the music
#

if [[ -z $link_addr ]];
then
	echo "song not found"
	exit 1
else
	if [ -z "$2" ]; then
		mpv $link_addr --loop --no-video &>/dev/null &
		echo "playing '$1'"
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

