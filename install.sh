#!/bin/bash

# ask user if there's a local song directory
#
#
#


set(){
	if [ -z "${!1}" ];
	then
		read -p "provide address of your $1 path: " SONGDIR
		echo "$1=$SONGDIR"
		echo "export $1=$SONGDIR" >> ~/.$(echo $SHELL | cut -d '/' -f $(echo $SHELL | tr '/' '\n' | wc -l))rc
	fi
}

set SONGDIR
set LYRCDIR
set fav_file

#set the link for the files

sudo ln -s $PWD/play.sh /usr/local/bin/play
sudo ln -s $PWD/play.sh /usr/local/bin/playmusic
