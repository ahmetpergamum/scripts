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
For sending notifications with email
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
#### Enabling tags from the taxonomies
For using already defined tags, some taxonomies should be enabled.
```
Event actions > List Taxonomies > Push the plus sign of relavant taxonomy > Enable all tgs in it
```

#### Enabling delegation of events
When the delegation of events is desired for anonymity, it should be enabled in MISP administrative settings.

Additionally it should be at least two organisations registered to the same MISP instance. One of them request delegation and the other accepts and take ownership of the event.

Check the settings from `Administration > Server Settings > MISP.delegation true`

To enable delegation:

```
$CAKE Admin setSetting "MISP.delegation" true
```
#### Definition of NIDS SID
SID (Signature IDentification) is a unique ID for rules used in Snort and Suricata.

When creating a user account in MISP, it is possible to add the SID range that will be used to generate IDS rules. It would be good to propose a valid default value.

By default an SID is set when creating new users.

[Source of the discussion](https://github.com/MISP/MISP/issues/538)

#### Definition of UUIDs

It's an identification number that will uniquely identify something. The idea being that that id number will be universally unique. Thus, no two things should have the same uuid.

UUIDs are defined in RFC 4122. They're Universally Unique IDentifiers, that can be generated without the use of a centralized authority. There are four major types of UUIDs which are used in slightly different scenarios. All UUIDs are 128 bits in length, but are commonly represented as 32 hexadecimal characters separated by four hyphens.

[Source of the discussion](https://stackoverflow.com/questions/292965/what-is-a-uuid)

#### Need for reinstalling misp-modules

After the initial installation of misp-modules it is needed to reinstall it again in order to run free of error.

Error before the reinstall `ModuleNotFoundError: No module named 'misp_modules'`

```
cd /usr/local/src/misp-modules
sudo pip3 install -I -r REQUIREMENTS
sudo pip3 install -I .
pip3 install maec lief python-magic wand yara
pip3 install git+https://github.com/kbandla/pydeep.git
# sudo vi /etc/rc.local, add this line: `sudo -u www-data misp-modules -s &`
misp-modules #to start the modules
```


#### Enabling a module after running misp modules

For viewing the module settings:` Administration > Server Settings > Plugin Settings`

Thre will be no module settings would be seen in web interface if the modules is not started by cli.

After running misp-modules specified module can be enabled.

```
$CAKE Admin setSetting "Plugin.Import_cuckooimport_enabled" true
$CAKE Admin setSetting "Plugin.Import_services_url" http://<fqdn>
$CAKE Admin setSetting "Plugin.Import_services_port" <port-nu>
```

#### MISP modules documentation


MISP modules help instructions.

```
misp-modules -h
unsupported locale setting
usage: misp-modules [-h] [-t] [-s] [-d] [-p P] [-l L] [-m M]

misp-modules server

optional arguments:
  -h, --help  show this help message and exit
  -t          Test mode
  -s          Run a system install (package installed via pip)
  -d          Enable debugging
  -p P        misp-modules TCP port (default 6666)
  -l L        misp-modules listen address (default localhost)
  -m M        Register a custom module
```

To change the listening server address and port
```
misp-modules -l <ip-add> -p <port-add>
```

