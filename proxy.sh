#!/bin/bash
SERVER=server_ip
PORT=server_port

# assign empty string if there is no authentication
USER="aaa:"
#PASS="12345"
PASS="aaaa@"

# if the first parameter is the new password
# it changes the password
if [ $1 ]
then
	sed -i "s/$PASS/$1@/" /etc/environment
	sed -i "s/$PASS/$1@/" /etc/apt/apt.conf
	sed -i "s/$PASS/$1@/" /etc/wgetrc

fi

FILE="/etc/environment"
grep $SERVER $FILE &> /dev/null
if [ $? -ne 0 ]
then
cat <<EOF >> $FILE
http_proxy="http://$USER$PASS$SERVER:$PORT/"
https_proxy="http://$USER$PASS$SERVER:$PORT/"
ftp_proxy="http://$USER$PASS$SERVER:$PORT/"
socks_proxy="socks://$USER$PASS$SERVER:$PORT/"
no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
HTTP_PROXY="http://$USER$PASS$SERVER:$PORT/"
HTTPS_PROXY="http://$USER$PASS$SERVER:$PORT/"
FTP_PROXY="http://$USER$PASS$SERVER:$PORT/"
SOCKS_PROXY="socks://$USER$PASS$SERVER:$PORT/"
NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
EOF
fi

FILE="/etc/apt/apt.conf"
grep $SERVER $FILE &> /dev/null
if [ $? -ne 0 ]
then
cat <<EOF >> $FILE
Acquire::http::proxy "http://$USER$PASS$SERVER:$PORT/";
Acquire::https::proxy "https://$USER$PASS$SERVER:$PORT/";
Acquire::ftp::proxy "ftp://$USER$PASS$SERVER:$PORT/";
Acquire::socks::proxy "socks://$USER$PASS$SERVER:$PORT/";
EOF
fi

FILE="/etc/wgetrc"
grep $SERVER $FILE &> /dev/null
if [ $? -ne 0 ]
then
cat <<EOF >> $FILE
use_proxy=yes
http_proxy=http://$USER$PASS$SERVER:$PORT/
EOF
fi
