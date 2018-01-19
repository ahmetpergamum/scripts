#!/bin/bash
sleep 10
RES=$(xrandr -q | grep \* | awk '{print $1}')
if [ "$RES" != "1920_1080_60.00" ];then
	OUTPUT=$(xrandr | grep primary | awk '{print $1}')
	echo $OUTPUT
	PARAM=$(gtf 1920 1080 60 | grep Modeline | awk -F "\"" '{print $3}')
	xrandr --newmode "1920_1080_60.00" $PARAM
	xrandr --addmode $OUTPUT "1920_1080_60.00"
	xrandr --output $OUTPUT --mode "1920_1080_60.00"
fi
