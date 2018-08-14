#!/bin/bash
# script for locking the screen after certa,n amount of time
# especially useful for pomodoro-25min intervals


for i in {1..5}
do
	sleep 300
	echo "$((5*$i)) minutes passed.."
done

# detect the gui type
GUI=$XDG_CURRENT_DESKTOP

GUI=${GUI,,}	# convert to lowercase

# do the suitable command to lock screen
if [ $GUI == "xfce" ]; then
	xflock4
elif [ $GUI == "gnome" or $GUI == "unity" ]; then
	gnome-screensaver-command -l
fi

sleep 300
echo "5 minutes rested...start!"
