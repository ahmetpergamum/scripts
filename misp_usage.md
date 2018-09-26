MISP USAGE INSTRUCTIONS for Debian 9 "stretch" server
-----------------------------------------------------

### Problems during installation
- In order to install pyhon-stix you should upgrade python 3.6 on debian 9
```
sudo nano /etc/apt/sources.list
# add
deb http://ftp.de.debian.org/debian testing main
echo 'APT::Default-Release "stable";' | sudo tee -a /etc/apt/apt.conf.d/00local
sudo apt-get update
sudo apt-get -t testing install python3.6
python3.6 -V
```
- There is not a solution for maec installation error



### Problems during installation
- For execution error logs look up the `/var/www/MISP/app/tmp/logs/exec-error.log` file
- In order to import stix formatted documents `/usr/local/lib/python3.6/dist-packages/pymisp/data/` permission error should be eliminated
```
chown -R :www-data /usr/local/lib/python3.6/dist-packages/pymisp/data/
```
