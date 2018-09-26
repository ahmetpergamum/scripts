MISP USAGE INSTRUCTIONS for Debian 9 "stretch" server
-----------------------------------------------------

### Problems during installation
#### python-stix installation
In order to install pyhon-stix you should upgrade python 3.6 on debian 9
```
sudo nano /etc/apt/sources.list
# add
deb http://ftp.de.debian.org/debian testing main
echo 'APT::Default-Release "stable";' | sudo tee -a /etc/apt/apt.conf.d/00local
sudo apt-get update
sudo apt-get -t testing install python3.6
python3.6 -V
```
#### python-maec installation
Could not installed maec with pip3 so installed it with setup.py.
```
cd $PATH_TO_MISP/app/files/scripts
git clone https://github.com/MAECProject/python-maec.git
python3 setup.py install
```

### Problems after installation
#### Importing stix documents
For execution error logs look up the `/var/www/MISP/app/tmp/logs/exec-error.log` file
There is a permission error while reading files.
In order to import stix formatted documents permission error should be eliminated with changing ownership of this directory `/usr/local/lib/python3.6/dist-packages/pymisp/data/`

```
chown -R :www-data /usr/local/lib/python3.6/dist-packages/pymisp/data/
```

#### Eliminate the email disabled error
- For sending notifications with email
```
$CAKE Admin setSetting "MISP.email" "<your-email-add>"
$CAKE Admin setSetting "MISP.disable_emailing" false
```

#### Delete failed jobs from database for not to show in web interface
- If a job fails restart a worker if it gets stuck, you should be able to do this from the workers tab in the admin interface.
- If all else fails, `flushdb` is a the nuclear option that will remove all worker queues, effectively killing the workers - but it should only be used if all else fails.
- The jobs in administration->jobs are informational only, no need to remove them. If a job fails it's gone for good.
- If you really want to remove them, simply log into MYSQL and run the following query:
```
delete from misp.jobs;
```
