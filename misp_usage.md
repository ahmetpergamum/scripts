MISP USAGE INSTRUCTIONS for Debian 9 "stretch" server
-----------------------------------------------------

### Problems during installation
#### python-stix installation error
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
#### python-maec installation error
- Could not installed maec with pip3 so installed it with setup.py.
```
cd $PATH_TO_MISP/app/files/scripts
git clone https://github.com/MAECProject/python-maec.git
python3 setup.py install
```

### Problems after installation
#### Import stix documents error
- For execution error logs look up the `/var/www/MISP/app/tmp/logs/exec-error.log` file
- In order to import stix formatted documents `/usr/local/lib/python3.6/dist-packages/pymisp/data/` permission error should be eliminated
```
chown -R :www-data /usr/local/lib/python3.6/dist-packages/pymisp/data/
```
