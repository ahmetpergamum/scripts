#!/bin/bash
# script to print two sided pdf files - first even pages then odd pages
# install pdftk first before running
# sudo apt install pdftk
# Usage : ./script_name <-e or -o> pdf_file
# $1: path-to-file
# $2: even or odd pages <-e or -o>
pageN=$(pdftk "$1" dump_data | grep NumberOfPages | awk '{print $2}')
echo "Number of pages: $pageN"

# generate evens
EVENS=""
for (( i=2; i<=$pageN; i=i+2 ))
do
	EVENS=$EVENS$(echo -n "$i,")
done
# cut the trailing comma
EVENS=$(echo "${EVENS::-1}")
echo $EVENS

# generate odds
ODDS=""
for (( i=1; i<=$pageN; i=i+2 ))
do
	ODDS=$ODDS$(echo -n "$i,")
done
# cut the trailing comma
ODDS=$(echo "${ODDS::-1}")
echo $ODDS

if [ "$#" -ne 2 ]
then
echo -e "\nScript to print two sided pdf files - first even pages then odd pages\n\
Usage: $(basename $0) <path-to-pdf-file> <-e|-o> \n\
	  -e for even pages -o for odd pages\n"
exit 0
fi

# print even or odd pages
if [ "$2" = "-e" ]
then
	lp -P $EVENS $1
elif [ "$2" = "-o" ]
then
	lp -P $ODDS $1
fi
