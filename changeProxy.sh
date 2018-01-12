#!/bin/bash
echo "Proxy User Name:"
read USER
echo "Proxy Password:"
read -s PASSW


sed -i "s/\/.*172/\/\/$USER:$PASSW@172/" /etc/environment
sed -i "s/\/.*172/\/\/$USER:$PASSW@172/" /etc/wgetrc
sed -i "s/\/.*172/\/\/$USER:$PASSW@172/" /etc/apt/apt.conf
sed -i "s/\/.*172/\/\/$USER:$PASSW@172/" /root/.bashrc
sed -i "s/\/.*172/\/\/$USER:$PASSW@172/" /root/.gitconfig
exit 0
