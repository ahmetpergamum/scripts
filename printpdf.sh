#!/bin/bash
# not completed!!!
# install pdftk first before running


# file=$1
pageN=$(pdftk "$1" dump_data | grep NumberOfPages | awk '{print $2}')
echo $pageN

if [ $((pageN%2)) -eq 0 ]
then
	c=$((pageN/2))
else
	c=$(((pageN-1)/2))
fi

for i in $(seq 0 $c)
do
	echo $((i * 2))
done

# if []
# then
# 	lp -P $EVENS $1
# elif[]
# 	lp -P $ODDS $1
# fi
