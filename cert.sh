#!/bin/bash
# ca-certificate configuration script
# run the script at the directory that the .pem file resides

pemFile=$(ls *.pem)
certName=$(ls *.pem | awk -F"." '{print $1}')
certFile="$certName.crt"
openssl x509 -in $pemFile -inform PEM -out $certFile

sudo mkdir /usr/share/ca-certificates/$certName
sudo cp $certFile /usr/share/ca-certificates/$certName/.
sudo dpkg-reconfigure ca-certificates

# change pip conf file
sudo echo "[global]" >> /etc/pip.conf
sudo echo "cert = /usr/share/ca-certificates/$certName/$certFile" >> /etc/pip.conf

echo Done!...
