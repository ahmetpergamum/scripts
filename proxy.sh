#!/bin/bash

# proxy settings for environment, apt and wget
echo "Proxy Server Address"
read SERVER
echo "Proxy Server Port"
read PORT
echo "Proxy User Name:"
read USERNAME
echo "Proxy Password:"
read -s PASSW


FILE="~/.bashrc"
# dosyada kullanici sifre iceren proxy patterni var mi
grep "://.*@.*[0-9]:[0-9]" $FILE &> /dev/null
# varsa sadece kullanici adi sifre ve sunucu bilgilerini degistir
if [ $? -eq 0 ]
then
	sudo sed -i "s/\:\/\/.*@.*$/\:\/\/$USERNAME:$PASSW\@$SERVER:$PORT\//" $FILE
	source $FILE
else
 	sudo sed -i "\$aexport http_proxy=http://$USERNAME.$PASSW@$SERVER:$PORT" $FILE
 	sudo sed -i "\$aexport https_proxy=https://$USERNAME.$PASSW@$SERVER:$PORT" $FILE
	source $FILE
fi

FILE="/etc/wgetrc"
# dosyada kullanici sifre iceren proxy patterni var mi
grep "://.*@.*[0-9]:[0-9]" $FILE &> /dev/null
# varsa sadece kullanici adi sifre ve sunucu bilgilerini degistir
if [ $? -eq 0 ]
then
	sudo sed -i "s/\:\/\/.*@.*$/\:\/\/$USERNAME:$PASSW\@$SERVER:$PORT\//" $FILE
else
	sudo sed -i "\$ause_proxy=yes" $FILE
	sudo sed -i "\$ahttp_proxy=http://$USERNAME:$PASSW@$SERVER:$PORT/" $FILE
	sudo sed -i "\$ahttps_proxy=https://$USERNAME:$PASSW@$SERVER:$PORT/" $FILE
fi

FILE="/etc/environment"
grep "://.*@.*[0-9]:[0-9]" $FILE &> /dev/null
# varsa sadece kullanici adi sifre ve sunucu bilgilerini degistir
if [ $? -eq 0 ]
then
	sudo sed -i "s/\:\/\/.*@.*$/\:\/\/$USERNAME:$PASSW\@$SERVER:$PORT\//" $FILE
else
	sudo sed -i "\$ahttp_proxy="http://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$ahttps_proxy="http://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$aftp_proxy="http://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$asocks_proxy="socks://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$ano_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"" $FILE
	sudo sed -i "\$aHTTP_PROXY="http://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$aHTTPS_PROXY="http://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$aFTP_PROXY="http://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$aSOCKS_PROXY="socks://$USERNAME:$PASSW@$SERVER:$PORT/"" $FILE
	sudo sed -i "\$aNO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"" $FILE
fi
FILE="/etc/apt/apt.conf"
# dosyada kullanici sifre iceren proxy patterni var mi
grep "://.*@.*[0-9]:[0-9]" $FILE &> /dev/null
# varsa sadece kullanici adi sifre ve sunucu bilgilerini degistir
if [ $? -eq 0 ]
then
	sudo sed -i "s/\:\/\/.*@.*$/\:\/\/$USERNAME:$PASSW\@$SERVER:$PORT\//" $FILE
else
	sudo sed -i "\$aAcquire::http::proxy "http://$USERNAME:$PASSW@$SERVER:$PORT/";" $FILE
	sudo sed -i "\$aAcquire::https::proxy "https://$USERNAME:$PASSW@$SERVER:$PORT/";" $FILE
	sudo sed -i "\$aAcquire::ftp::proxy "ftp://$USERNAME:$PASSW@$SERVER:$PORT/";" $FILE
	sudo sed -i "\$aAcquire::socks::proxy "socks://$USERNAME:$PASSW@$SERVER:$PORT/";" $FILE
fi

FILE="~/.gitconfig"
# dosyada kullanici sifre iceren proxy patterni var mi
grep "://.*@.*[0-9]:[0-9]" $FILE &> /dev/null
# varsa sadece kullanici adi sifre ve sunucu bilgilerini degistir
if [ $? -eq 0 ]
then
	sudo sed -i "s/\:\/\/.*@.*$/\:\/\/$USERNAME:$PASSW\@$SERVER:$PORT\//" $FILE
else
	git config --global http.proxy http://$USERNAME:$PASSW@$SERVER:$PORT
	git config --global https.proxy https://$USERNAME:$PASSW@$SERVER:$PORT
fi

# 	export http_proxy=http://$SERVER:$PORT
# 	export https_proxy=https://$SERVER:$PORT
#
#
#
echo "Done..."
