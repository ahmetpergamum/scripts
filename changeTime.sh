#/bin/bash

ls | grep "JPG\|MOV" > filenames.txt
while read line
do
	tstamp=$(exiftool $line | grep "Create Date"  | awk '{print $4}' | \
		awk -F ":" '{print $1$2$3}' | head -1)
	echo $tstamp
	echo $line
	touch -m -t ${tstamp}0000 $line
	sleep 1
done<filenames.txt
