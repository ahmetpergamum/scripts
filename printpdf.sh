#!/bin/bash
# not completed!!!
# install pdftk first before running
# run : ./script_name <-e or -o> pdf_file
# file=$1
pageN=$(pdftk "$1" dump_data | grep NumberOfPages | awk '{print $2}')
echo "Number of pages: $pageN"

# generate odds
ODDS=""
for (( i=1; i<=$pageN; i=i+2 ))
do
	ODDS=$ODDS$(echo -n "$i,")
done
# cut the trailing comma
ODDS=$(echo "${ODDS::-1}")
echo $ODDS

# generate evens
EVENS=""
for (( i=2; i<=$pageN; i=i+2 ))
do
	EVENS=$EVENS$(echo -n "$i,")
done
# cut the trailing comma
EVENS=$(echo "${EVENS::-1}")
echo $EVENS

# print even or odd pages
if [ "$2" = "-e" ]
then
	lp -P $EVENS $1
elif [ "$2" = "-o" ]
then
	lp -P $ODDS $1
fi
