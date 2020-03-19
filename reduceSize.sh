#!/bin/bash
# script to reduce the size of video files
# first parameter is filename
# second parameter is target size in MBs
# requirement
# sudo apt install ffmpeg

# target size MB
TARGETMB=$2

# calculate the duraion in secs
DURATION=$(ffmpeg -i $1 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//)
HOUR=$(echo $DURATION | awk -F: '{print $1}')
MIN=$(echo $DURATION | awk -F: '{print $2}')
SEC=$(echo $DURATION | awk -F: '{print $3}' | awk -F. '{print $1}')
echo "$HOUR hours $MIN mins $SEC secs"
TOTALSEC=$(($((HOUR*3600))+$((MIN*60))+SEC))
echo "$TOTALSEC secs"

# calculate the bitrate in kbits per sec
TARGETBIT=$((TARGETMB*8*1024*1024))
echo "$TARGETMB MByte is $TARGETBIT bits"
BITRATE=$((TARGETBIT/TOTALSEC/1024))
echo "Script will convert the file with $BITRATE kbits per sec bitrate"

# run the program and out to a new file with '_'
ffmpeg -i $1 -b ${BITRATE}k _$1

