#!/bin/bash
# take screenshot and make a gif

# chmod script to an executable
# chmod +x scriptname
# usage
# ./scriptname

# required packages
# sudo apt install imagemagick
# sudo apt install gthumb
# sudo apt install eog

# # open url with fullscreen
google-chrome --start-fullscreen metu.edu.tr &
sleep 8

# capture the screen and save as a png file
for i in {0..9}
do
	xwd -root | convert - capture$i.png
	echo "image $i captured"
	sleep 10
done

# kill chrome browser
pkill chrome

# convert png images to a gif file with 5 seconds delay
convert -delay 500 -loop 0 *.png animation.gif

# open gif in fullscreen
eog -f animation.gif
