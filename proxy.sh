#!/bin/bash

# proxy settings for environment, apt and wget
SERVER=172.80.1.1
PORT=8080

function setproxy{

if [ $# -ne 4 ] && [ $# -ne 0 ]
then
	echo "Usage for proxy settings with auth:"
	echo "$0 -u username -p password"
	echo "Usage for proxy settings without auth:"
	echo "$0"
	exit
fi

# assign empty string if there is no authentication
# do not give any command line parameter
if [ $# -eq 0 ]
then
	USER=""
	PASS=""
	echo "Proxy settings without authentication!!!"
fi
if [ "$1" == "-u" ]
then
	USER="$2:"
fi
if [ "$3" == "-p" ]
then
	PASS="$4@"
	echo "Proxy settings with authentication!!!"
fi


FILE="/etc/environment"
grep $SERVER $FILE &> /dev/null
if [ $? -eq 0 ]
then
	sed -i "/$SERVER/d" $FILE
else
	echo "no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"" >> $FILE
	echo "NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"" >> FILE
fi

cat <<EOF >> $FILE
http_proxy="http://$USER$PASS$SERVER:$PORT/"
https_proxy="http://$USER$PASS$SERVER:$PORT/"
ftp_proxy="http://$USER$PASS$SERVER:$PORT/"
socks_proxy="socks://$USER$PASS$SERVER:$PORT/"
HTTP_PROXY="http://$USER$PASS$SERVER:$PORT/"
HTTPS_PROXY="http://$USER$PASS$SERVER:$PORT/"
FTP_PROXY="http://$USER$PASS$SERVER:$PORT/"
SOCKS_PROXY="socks://$USER$PASS$SERVER:$PORT/"
EOF

FILE="/etc/apt/apt.conf"
grep $SERVER $FILE &> /dev/null
if [ $? -eq 0 ]
then
	sed -i "/$SERVER/d" $FILE
fi
cat <<EOF >> $FILE
Acquire::http::proxy "http://$USER$PASS$SERVER:$PORT/";
Acquire::https::proxy "https://$USER$PASS$SERVER:$PORT/";
Acquire::ftp::proxy "ftp://$USER$PASS$SERVER:$PORT/";
Acquire::socks::proxy "socks://$USER$PASS$SERVER:$PORT/";
EOF

FILE="/etc/wgetrc"
grep $SERVER $FILE &> /dev/null
if [ $? -eq 0 ]
then
	sed -i "/$SERVER/d" $FILE
else
	echo "use_proxy=yes" >> $FILE
fi
echo "http_proxy=http://$USER$PASS$SERVER:$PORT/" >> $FILE
echo "https_proxy=https://$USER$PASS$SERVER:$PORT/" >> $FILE

echo "Done..."
}
