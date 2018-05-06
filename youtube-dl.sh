#!/bin/bash

dir=$(pwd)
if [ $# -eq 0 ]; then

	while read line
	do
		youtube-dl -o "$dir/%(title)s.%(ext)si" -i -x --audio-format mp3 $line
		#youtube-dl -o '%(title)s.%(ext)s' --restrict-filenames -i -x --audio-format mp3 $line
	done<$dir/liste
elif [ $1 == "-v" ]; then
	while read line
	do
		youtube-dl -f mp4 -o "$dir/%(title)s.%(ext)s" -i  $line --verbose --no-check-certificate
		#youtube-dl -f mp4 -o '/home/admin1/Music/%(title)s.%(ext)s' -i  $line
	done<$dir/liste
elif [ $1 == "-u" ]; then
	while read line
	do
		youtube-dl -o "$dir/%(title)s.%(ext)si" -i -x --audio-format mp3 -u ahmet.pergamum $line
		#youtube-dl -o '%(title)s.%(ext)s' --restrict-filenames -i -x --audio-format mp3 $line
	done<$dir/liste
else
	echo "Usage for video download	: $0 -v"
	echo "for audio download	: $0"
	echo "for audio download with username	: $0 -u"
fi
