#!/bin/bash
# not completed!!!
# install pdftk first before running
# run : ./script_name <-e or -o> pdf_file
# file=$1
pageN=$(pdftk "$2" dump_data | grep NumberOfPages | awk '{print $2}')
echo "Number of pages: $pageN"

# generate odds
ODDS=""
for (( i=1; i<=$pageN; i=i+2 ))
do
	ODDS=$ODDS$(echo -n "$i,")
done
# cut the trailing comma
ODDS=$(echo "${ODDS::-1}")

# generate evens
EVENS=""
for (( i=2; i<=$pageN; i=i+2 ))
do
	EVENS=$EVENS$(echo -n "$i,")
done
# cut the trailing comma
EVENS=$(echo "${EVENS::-1}")
# generate even page numbers

if [ "$1" = "-e" ]
then
	echo $EVENS
	lp -P $EVENS $2
elif [ "$1" = "-o" ]
then
	echo $ODDS
	lp -P $ODDS $2
fi
