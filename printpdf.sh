#!/bin/bash
# not completed!!!
# install pdftk first before running


# file=$1
pageN=$(pdftk "$1" dump_data | grep NumberOfPages | awk '{print $2}')
echo $pageN

for i in $(seq 1 $pageN)
do
	echo $i
done
