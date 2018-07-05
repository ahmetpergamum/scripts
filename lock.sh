#!/bin/bash
# script for locking the screen after certa,n amount of time
# especially useful for pomodoro-25min intervals

sleep 600
echo "10 minutes"
sleep 300
echo "15 minutes"
sleep 300
echo "20 minutes"
sleep 300
sleep 300
echo "30 minutes"
sleep 300
sleep 300
echo "40 minutes"
sleep 300
sleep 300

# detect the gui type
GUI=$XDG_CURRENT_DESKTOP

GUI=${GUI,,}	# convert to lowercase

# do the suitable command to lock screen
if [ $GUI == "xfce" ]; then
	xflock4
elif [ $GUI == "gnome" or $GUI == "unity" ]; then
	gnome-screensaver-command -l
fi

