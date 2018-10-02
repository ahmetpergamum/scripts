INSTALLATION INSTRUCTIONS for Debian 9 "stretch" server
-------------------------------------------------------

0/ MISP debian stable install - Status
--------------------------------------

### Some configurables used below:

```
# MISP configuration variables
PATH_TO_MISP='/var/www/MISP'
CAKE="$PATH_TO_MISP/app/Console/cake"
MISP_BASEURL=''
MISP_LIVE='1'

# Database configuration
DBHOST='localhost'
DBNAME='misp'
DBUSER_ADMIN='root'
DBUSER_MISP='misp'
#DBPASSWORD_ADMIN="$(openssl rand -hex 32)"
DBPASSWORD_ADMIN="db_admin(root)_password"
#DBPASSWORD_MISP="$(openssl rand -hex 32)"
DBPASSWORD_MISP="db_user(misp)_password"

# Webserver configuration
FQDN='localhost'

# OpenSSL configuration
OPENSSL_CN='Common Name'
OPENSSL_C='LU'
OPENSSL_ST='State'
OPENSSL_L='Location'
OPENSSL_O='Organization'
OPENSSL_OU='Organizational Unit'
OPENSSL_EMAILADDRESS='info@localhost'

# GPG configuration
GPG_REAL_NAME='Autogenerated Key'
GPG_COMMENT='WARNING: MISP AutoGenerated Key consider this Key VOID!'
#GPG_EMAIL_ADDRESS='admin@admin.test'
#GPG_EMAIL_ADDRESS=<corp_email_addr>
GPG_KEY_LENGTH='2048'
#GPG_PASSPHRASE='Password1234'

# php.ini configuration
upload_max_filesize=50M
post_max_size=50M
max_execution_time=300
memory_limit=512M
PHP_INI=/etc/php/7.0/apache2/php.ini

echo "Admin (root) DB Password: $DBPASSWORD_ADMIN"
echo "User  (misp) DB Password: $DBPASSWORD_MISP"
```

1/ Minimal Debian install
-------------------------

### Install a minimal Debian 9 "stretch" server system with the software:
- OpenSSH server
```
apt install openssh-server
```
- Web server, apache FTW!
```
apt install apache2
```
- This guide assumes a user name of 'misp'

### Install firewall for security
- UFW is preferred
```
apt install ufw
```
- Allow ssh connections first
```
ufw allow ssh
```
- Allow www connections from IP address that you made ssh with
```
ufw allow from $(netstat -antlp | grep "ESTABLISHED.*ssh" | awk '{print $5}' | awk -F':' '{print $1}' | grep -v "127.0.0.1" ) to any port 80
```
- Finally define the default rule and enable
```
ufw default deny incoming
ufw default allow outgoing
ufw enable
```
- View ufw status with numbered and delete any rules with ruke number
```
ufw status numbered
ufw delete <# of rule>
```

### Install sudo
- Debian does not come with sudo installed

```
apt install sudo
```

### Install etckeeper (optional)

```
su -
apt install etckeeper
apt install sudo
adduser misp sudo
```

### Make sure your system is up2date:

```
apt update
apt -y dist-upgrade
```

### Network Interface Name salvage (optional)

This will bring back 'ethX' e.g: eth0

```
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
DEFAULT_GRUB=/etc/default/grub
for key in GRUB_CMDLINE_LINUX
do
    sudo sed -i "s/^\($key\)=.*/\1=\"$(eval echo \${$key})\"/" $DEFAULT_GRUB
done
grub-mkconfig -o /boot/grub/grub.cfg
```

### Install postfix, there will be some questions.
```
apt install -y postfix
```
### Postfix Configuration: Satellite system
### change the relay server later with:
```
postconf -e 'relayhost = example.com'
postfix reload
```


2/ Install LAMP & dependencies
------------------------------
Once the system is installed you can perform the following steps:

### Install all the dependencies: (some might already be installed)
```
apt install -y \
curl gcc git gnupg-agent make openssl redis-server vim zip libyara-dev python3-yara python3-redis python3-zmq \
mariadb-client mariadb-server \
apache2 apache2-doc apache2-utils \
libapache2-mod-php7.0 php7.0 php7.0-cli php7.0-dev php7.0-json php7.0-xml php7.0-mysql php7.0-readline php-redis \
php7.0-mbstring php-pear python3 python3-dev python3-pip libpq5 libjpeg-dev libfuzzy-dev ruby asciidoctor \
libxml2-dev libxslt1-dev zlib1g-dev python3-setuptools
```

### Start rng-tools to get more entropy (optional)
### If you get TPM errors, enable "Security chip" in BIOS (keep secure boot disabled)
```
apt install rng-tools
service rng-tools start
```

### Secure the MariaDB installation (especially by setting a strong root password)
```
mysql_secure_installation
```

### Enable modules, settings, and default of SSL in Apache
```
a2dismod status
a2enmod ssl rewrite
a2dissite 000-default
a2ensite default-ssl
```

### Install PHP external dependencies
```
pear channel-update pear.php.net
pear install Crypt_GPG
```

### Switch to python3 by default (optional)

```
update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
update-alternatives --install /usr/bin/python python /usr/bin/python3.5 2
```
- To flip between the 2 pythons

```
	sudo update-alternatives --config python
```

### Apply all changes
```
systemctl restart apache2
```


3/ MISP code
------------
### Download MISP using git in the /var/www/ directory.
```
mkdir $PATH_TO_MISP
chown www-data:www-data $PATH_TO_MISP
cd $PATH_TO_MISP
sudo -u www-data git clone https://github.com/MISP/MISP.git $PATH_TO_MISP
```

### Make git ignore filesystem permission differences
```
sudo -u www-data git config core.filemode false
```

```
cd $PATH_TO_MISP/app/files/scripts
sudo -u www-data git clone https://github.com/CybOXProject/python-cybox.git
sudo -u www-data git clone https://github.com/STIXProject/python-stix.git
cd $PATH_TO_MISP/app/files/scripts/python-cybox
pip3 install .
cd $PATH_TO_MISP/app/files/scripts/python-stix
pip3 install .
```

### Install mixbox to accomodate the new STIX dependencies:
```
cd $PATH_TO_MISP/app/files/scripts/
sudo -u www-data git clone https://github.com/CybOXProject/mixbox.git
cd $PATH_TO_MISP/app/files/scripts/mixbox
pip3 install .
```

```
cd $PATH_TO_MISP
sudo -u www-data git submodule update --init --recursive
```
### Make git ignore filesystem permission differences for submodules
```
sudo -u www-data git submodule foreach --recursive git config core.filemode false
```

### Install PyMISP
```
cd $PATH_TO_MISP/PyMISP
pip3 install .
```

4/ CakePHP
-----------
CakePHP is included as a submodule of MISP.

### Install CakeResque along with its dependencies if you intend to use the built in background jobs
```
cd $PATH_TO_MISP/app
```
### Make composer cache happy
```
mkdir /var/www/.composer ; sudo chown www-data:www-data /var/www/.composer
sudo -u www-data php composer.phar require kamisama/cake-resque:4.1.2
sudo -u www-data php composer.phar config vendor-dir Vendor
sudo -u www-data php composer.phar install
```

### Enable CakeResque with php-redis
```
phpenmod redis
```

### To use the scheduler worker for scheduled tasks, do the following:
```
sudo -u www-data cp -fa $PATH_TO_MISP/INSTALL/setup/config.php $PATH_TO_MISP/app/Plugin/CakeResque/Config/config.php
```


5/ Set the permissions
----------------------

### Check if the permissions are set correctly using the following commands:
```
chown -R www-data:www-data $PATH_TO_MISP
chmod -R 750 $PATH_TO_MISP
chmod -R g+ws $PATH_TO_MISP/app/tmp
chmod -R g+ws $PATH_TO_MISP/app/files
chmod -R g+ws $PATH_TO_MISP/app/files/scripts/tmp
```


6/ Create a database and user
-----------------------------
### Enter the mysql shell
```
mysql -u root -p
```

```
MariaDB [(none)]> create database misp;
MariaDB [(none)]> grant usage on *.* to misp@localhost identified by 'XXXXdbpasswordhereXXXXX';
MariaDB [(none)]> grant all privileges on misp.* to misp@localhost;
MariaDB [(none)]> flush privileges;
MariaDB [(none)]> exit
```

- Copy/paste commands below (same things with above commands without logging in) :
```
mysql -u $DBUSER_ADMIN -p$DBPASSWORD_ADMIN -e "create database $DBNAME;"
mysql -u $DBUSER_ADMIN -p$DBPASSWORD_ADMIN -e "grant usage on *.* to $DBNAME@localhost identified by '$DBPASSWORD_MISP';"
mysql -u $DBUSER_ADMIN -p$DBPASSWORD_ADMIN -e "grant all privileges on $DBNAME.* to '$DBUSER_MISP'@'localhost';"
mysql -u $DBUSER_ADMIN -p$DBPASSWORD_ADMIN -e "flush privileges;"
```
```
mysql -u root -p$DBPASSWORD_ADMIN -e "create database misp;"
mysql -u root -p$DBPASSWORD_ADMIN -e "grant usage on *.* to misp@localhost identified by '$DBPASSWORD_MISP';"
mysql -u root -p$DBPASSWORD_ADMIN -e "grant all privileges on misp.* to 'misp'@'localhost';"
mysql -u root -p$DBPASSWORD_ADMIN -e "flush privileges;"
```

### Import the empty MISP database from MYSQL.sql
```
sudo -u www-data cat $PATH_TO_MISP/INSTALL/MYSQL.sql | mysql -u $DBUSER_MISP -p$DBPASSWORD_MISP $DBNAME
```

7/ Apache configuration
-----------------------
### Now configure your Apache webserver with the DocumentRoot $PATH_TO_MISP/app/webroot/

### If the apache version is 2.4:
```
apache2 -v
cp $PATH_TO_MISP/INSTALL/apache.24.misp.ssl /etc/apache2/sites-available/misp-ssl.conf
```

Be aware that the configuration files for apache 2.4 and up have changed.
The configuration file has to have the .conf extension in the sites-available directory
For more information, visit http://httpd.apache.org/docs/2.4/upgrading.html

### If a valid SSL certificate is not already created for the server, create a self-signed certificate:
```
openssl req -newkey rsa:4096 -days 365 -nodes -x509 \
-subj "/C=${OPENSSL_C}/ST=${OPENSSL_ST}/L=${OPENSSL_L}/O=${OPENSSL_O}/OU=${OPENSSL_OU}/CN=${OPENSSL_CN}/emailAddress=${OPENSSL_EMAILADDRESS}" \
-keyout /etc/ssl/private/misp.local.key -out /etc/ssl/private/misp.local.crt
```

### Otherwise, copy the SSLCertificateFile, SSLCertificateKeyFile, and SSLCertificateChainFile to /etc/ssl/private/. (Modify path and config to fit your environment)

### Change SSL configuration file with the sample above
```
sudo vi /etc/apache2/sites-available/misp-ssl.conf
```
### Sample working SSL config for MISP
```
# do not use localhost as FQDN for connecting remotely
<VirtualHost <IP, FQDN, or *>:80>
        ServerAdmin admin@<your.FQDN.here>
        ServerName <your.FQDN.here>

		# do not use localhost
        Redirect permanent / https://<your.FQDN_or_IP.here>

        LogLevel warn
        ErrorLog /var/log/apache2/misp.local_error.log
        CustomLog /var/log/apache2/misp.local_access.log combined
        ServerSignature Off
</VirtualHost>

<VirtualHost <IP, FQDN, or *>:443>
        ServerAdmin admin@<your.FQDN.here>
        ServerName <your.FQDN.here>
        DocumentRoot $PATH_TO_MISP/app/webroot
        <Directory $PATH_TO_MISP/app/webroot>
                Options -Indexes
                AllowOverride all
                Order allow,deny
                allow from all
        </Directory>

        SSLEngine On
        SSLCertificateFile /etc/ssl/private/misp.local.crt
        SSLCertificateKeyFile /etc/ssl/private/misp.local.key
#        SSLCertificateChainFile /etc/ssl/private/misp-chain.crt

        LogLevel warn
        ErrorLog /var/log/apache2/misp.local_error.log
        CustomLog /var/log/apache2/misp.local_access.log combined
        ServerSignature Off
</VirtualHost>
```

### Activate new vhost
```
a2dissite default-ssl
a2ensite misp-ssl
```

### Recommended: Change some PHP settings in /etc/php/7.0/apache2/php.ini
```
max_execution_time = 300
memory_limit = 512M
upload_max_filesize = 50M
post_max_size = 50M
```
- This for loop makes all changes on php.ini file
```
for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
do
    sudo sed -i "s/^\($key\).*/\1 = $(eval echo \${$key})/" $PHP_INI
done
```

### Restart apache
```
systemctl restart apache2
```

8/ Log rotation
---------------
### MISP saves the stdout and stderr of its workers in $PATH_TO_MISP/app/tmp/logs
### To rotate these logs install the supplied logrotate script:

```
cp $PATH_TO_MISP/INSTALL/misp.logrotate /etc/logrotate.d/misp
chmod 0640 /etc/logrotate.d/misp
```

9/ MISP configuration
---------------------
### There are 4 sample configuration files in $PATH_TO_MISP/app/Config that need to be copied
```
sudo -u www-data cp -a $PATH_TO_MISP/app/Config/bootstrap.default.php $PATH_TO_MISP/app/Config/bootstrap.php
sudo -u www-data cp -a $PATH_TO_MISP/app/Config/database.default.php $PATH_TO_MISP/app/Config/database.php
sudo -u www-data cp -a $PATH_TO_MISP/app/Config/core.default.php $PATH_TO_MISP/app/Config/core.php
sudo -u www-data cp -a $PATH_TO_MISP/app/Config/config.default.php $PATH_TO_MISP/app/Config/config.php
```


```
echo "<?php
class DATABASE_CONFIG {
        public \$default = array(
                'datasource' => 'Database/Mysql',
                //'datasource' => 'Database/Postgres',
                'persistent' => false,
                'host' => '$DBHOST',
                'login' => '$DBUSER_MISP',
                'port' => 3306, // MySQL & MariaDB
                //'port' => 5432, // PostgreSQL
                'password' => '$DBPASSWORD_MISP',
                'database' => '$DBNAME',
                'prefix' => '',
                'encoding' => 'utf8',
        );
}" | sudo -u www-data tee $PATH_TO_MISP/app/Config/database.php

```
### Make sure the file permissions are still OK
```
chown -R www-data:www-data $PATH_TO_MISP/app/Config
chmod -R 750 $PATH_TO_MISP/app/Config
```
### Set some MISP directives with the command line tool
```
$CAKE Live $MISP_LIVE
```

### Change base url

- example: 'baseurl' => 'https://<your.FQDN.here>',
- alternatively, you can leave this field empty if you would like to use relative pathing in MISP
- 'baseurl' => '',

```
$CAKE Baseurl $MISP_BASEURL
```

### Make sure the file permissions are still OK
```
chown -R www-data:www-data $PATH_TO_MISP/app/Config
chmod -R 750 $PATH_TO_MISP/app/Config
```

### Generate a GPG encryption key.

```
cat >/tmp/gen-key-script <<EOF
    %echo Generating a default key
    Key-Type: default
    Key-Length: $GPG_KEY_LENGTH
    Subkey-Type: default
    Name-Real: $GPG_REAL_NAME
    Name-Comment: $GPG_COMMENT
    Name-Email: $GPG_EMAIL_ADDRESS
    Expire-Date: 0
    Passphrase: $GPG_PASSPHRASE
    # Do a commit here, so that we can later print "done"
    %commit
    %echo done
EOF
```

```
sudo -u www-data gpg --homedir $PATH_TO_MISP/.gnupg --batch --gen-key /tmp/gen-key-script
```
### The email address should match the one set in the config.php / set in the configuration menu in the administration menu configuration file

- Changed the email sections in $PATH_TO_MISP/app/Config/config.php with corp email add

# And export the public key to the webroot
```
sudo -u www-data sh -c "gpg --homedir $PATH_TO_MISP/.gnupg --export --armor $GPG_EMAIL_ADDRESS" | sudo -u www-data tee $PATH_TO_MISP/app/webroot/gpg.asc
```

### To make the background workers start on boot
```
chmod +x $PATH_TO_MISP/app/Console/worker/start.sh
```
```
if [ ! -e /etc/rc.local ]
then
    echo '#!/bin/sh -e' | sudo tee -a /etc/rc.local
    echo 'exit 0' | sudo tee -a /etc/rc.local
    sudo chmod u+x /etc/rc.local
fi
```

### Initialize user and fetch Auth Key
```
sudo -E $CAKE userInit -q
AUTH_KEY=$(mysql -u $DBUSER_MISP -p$DBPASSWORD_MISP misp -e "SELECT authkey FROM users;" | tail -1)
```

### Setup some more MISP default via cake CLI

#### Tune global time outs
```
$CAKE Admin setSetting "Session.autoRegenerate" 0
$CAKE Admin setSetting "Session.timeout" 600
$CAKE Admin setSetting "Session.cookie_timeout" 3600
```

#### Enable GnuPG
```
$CAKE Admin setSetting "GnuPG.email" "admin@admin.test"
$CAKE Admin setSetting "GnuPG.homedir" "$PATH_TO_MISP/.gnupg"
$CAKE Admin setSetting "GnuPG.password" "Password1234"
```

#### Enable Enrichment set better timeouts
```
$CAKE Admin setSetting "Plugin.Enrichment_services_enable" true
$CAKE Admin setSetting "Plugin.Enrichment_hover_enable" true
$CAKE Admin setSetting "Plugin.Enrichment_timeout" 300
$CAKE Admin setSetting "Plugin.Enrichment_hover_timeout" 150
$CAKE Admin setSetting "Plugin.Enrichment_cve_enabled" true
$CAKE Admin setSetting "Plugin.Enrichment_dns_enabled" true
$CAKE Admin setSetting "Plugin.Enrichment_services_url" "http://127.0.0.1"
$CAKE Admin setSetting "Plugin.Enrichment_services_port" 6666
```

#### Enable Import modules set better timout
```
$CAKE Admin setSetting "Plugin.Import_services_enable" true
$CAKE Admin setSetting "Plugin.Import_services_url" "http://127.0.0.1"
$CAKE Admin setSetting "Plugin.Import_services_port" 6666
$CAKE Admin setSetting "Plugin.Import_timeout" 300
$CAKE Admin setSetting "Plugin.Import_ocr_enabled" true
$CAKE Admin setSetting "Plugin.Import_csvimport_enabled" true
```

#### Enable Export modules set better timout
```
$CAKE Admin setSetting "Plugin.Export_services_enable" true
$CAKE Admin setSetting "Plugin.Export_services_url" "http://127.0.0.1"
$CAKE Admin setSetting "Plugin.Export_services_port" 6666
$CAKE Admin setSetting "Plugin.Export_timeout" 300
$CAKE Admin setSetting "Plugin.Export_pdfexport_enabled" true
```

#### Enable installer org and tune some configurables
```
$CAKE Admin setSetting "MISP.host_org_id" 1
$CAKE Admin setSetting "MISP.email" "info@admin.test"
$CAKE Admin setSetting "MISP.disable_emailing" true
$CAKE Admin setSetting "MISP.contact" "info@admin.test"
$CAKE Admin setSetting "MISP.disablerestalert" true
$CAKE Admin setSetting "MISP.showCorrelationsOnIndex" true
```

#### Provisional Cortex tunes
```
$CAKE Admin setSetting "Plugin.Cortex_services_enable" false
$CAKE Admin setSetting "Plugin.Cortex_services_url" "http://127.0.0.1"
$CAKE Admin setSetting "Plugin.Cortex_services_port" 9000
$CAKE Admin setSetting "Plugin.Cortex_timeout" 120
$CAKE Admin setSetting "Plugin.Cortex_services_url" "http://127.0.0.1"
$CAKE Admin setSetting "Plugin.Cortex_services_port" 9000
$CAKE Admin setSetting "Plugin.Cortex_services_timeout" 120
$CAKE Admin setSetting "Plugin.Cortex_services_authkey" ""
$CAKE Admin setSetting "Plugin.Cortex_ssl_verify_peer" false
$CAKE Admin setSetting "Plugin.Cortex_ssl_verify_host" false
$CAKE Admin setSetting "Plugin.Cortex_ssl_allow_self_signed" true
```

#### Various plugin sightings settings
```
$CAKE Admin setSetting "Plugin.Sightings_policy" 0
$CAKE Admin setSetting "Plugin.Sightings_anonymise" false
$CAKE Admin setSetting "Plugin.Sightings_range" 365
```

#### Plugin CustomAuth tuneable
```
$CAKE Admin setSetting "Plugin.CustomAuth_disable_logout" false
```

#### RPZ Plugin settings
```
$CAKE Admin setSetting "Plugin.RPZ_policy" "DROP"
$CAKE Admin setSetting "Plugin.RPZ_walled_garden" "127.0.0.1"
$CAKE Admin setSetting "Plugin.RPZ_serial" "\$date00"
$CAKE Admin setSetting "Plugin.RPZ_refresh" "2h"
$CAKE Admin setSetting "Plugin.RPZ_retry" "30m"
$CAKE Admin setSetting "Plugin.RPZ_expiry" "30d"
$CAKE Admin setSetting "Plugin.RPZ_minimum_ttl" "1h"
$CAKE Admin setSetting "Plugin.RPZ_ttl" "1w"
$CAKE Admin setSetting "Plugin.RPZ_ns" "localhost."
$CAKE Admin setSetting "Plugin.RPZ_ns_alt" ""
$CAKE Admin setSetting "Plugin.RPZ_email" "root.localhost"
```

#### Force defaults to make MISP Server Settings less RED
```
$CAKE Admin setSetting "MISP.language" "eng"
$CAKE Admin setSetting "MISP.proposals_block_attributes" false
```

##### Redis block
```
$CAKE Admin setSetting "MISP.redis_host" "127.0.0.1"
$CAKE Admin setSetting "MISP.redis_port" 6379
$CAKE Admin setSetting "MISP.redis_database" 13
$CAKE Admin setSetting "MISP.redis_password" ""
```

#### Force defaults to make MISP Server Settings less YELLOW
```
$CAKE Admin setSetting "MISP.ssdeep_correlation_threshold" 40
$CAKE Admin setSetting "MISP.extended_alert_subject" false
$CAKE Admin setSetting "MISP.default_event_threat_level" 4
$CAKE Admin setSetting "MISP.newUserText" "Dear new MISP user,\\n\\nWe would hereby like to welcome you to the \$org MISP community.\\n\\n Use the credentials below to log into MISP at \$misp, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: \$username\\nPassword: \$password\\n\\nIf you have any questions, don't hesitate to contact us at: \$contact.\\n\\nBest regards,\\nYour \$org MISP support team"
$CAKE Admin setSetting "MISP.passwordResetText" "Dear MISP user,\\n\\nA password reset has been triggered for your account. Use the below provided temporary password to log into MISP at \$misp, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: \$username\\nYour temporary password: \$password\\n\\nIf you have any questions, don't hesitate to contact us at: \$contact.\\n\\nBest regards,\\nYour \$org MISP support team"
$CAKE Admin setSetting "MISP.enableEventBlacklisting" true
$CAKE Admin setSetting "MISP.enableOrgBlacklisting" true
$CAKE Admin setSetting "MISP.log_client_ip" false
$CAKE Admin setSetting "MISP.log_auth" false
$CAKE Admin setSetting "MISP.disableUserSelfManagement" false
$CAKE Admin setSetting "MISP.block_event_alert" false
$CAKE Admin setSetting "MISP.block_event_alert_tag" "no-alerts=\"true\""
$CAKE Admin setSetting "MISP.block_old_event_alert" false
$CAKE Admin setSetting "MISP.block_old_event_alert_age" ""
$CAKE Admin setSetting "MISP.incoming_tags_disabled_by_default" false
$CAKE Admin setSetting "MISP.footermidleft" "This is an initial install"
$CAKE Admin setSetting "MISP.footermidright" "Please configure and harden accordingly"
$CAKE Admin setSetting "MISP.welcome_text_top" "Initial Install, please configure"
$CAKE Admin setSetting "MISP.welcome_text_bottom" "Welcome to MISP, change this message in MISP Settings"
```

#### Force defaults to make MISP Server Settings less GREEN
```
$CAKE Admin setSetting "Security.password_policy_length" 12
$CAKE Admin setSetting "Security.password_policy_complexity" '/^((?=.*\d)|(?=.*\W+))(?![\n])(?=.*[A-Z])(?=.*[a-z]).*$|.{16,}/'
```
#### Tune global time outs
```
$CAKE Admin setSetting "Session.autoRegenerate" 0
$CAKE Admin setSetting "Session.timeout" 600
$CAKE Admin setSetting "Session.cookie_timeout" 3600
```

### Now log in using the webinterface:
- Default user:pass
```
admin@admin.test:admin
```

- Using the server settings tool in the admin interface (Administration -> Server Settings), set MISP up to your preference
- It is especially vital that no critical issues remain!
- Start the workers by navigating to the workers tab and clicking restart all workers

- Don't forget to change the email, password and authentication key after installation.

### Set MISP Live
```
$CAKE Live $MISP_LIVE
```

### Update the galaxies…
```
$CAKE Admin updateGalaxies
```

### Updating the taxonomies…
```
$CAKE Admin updateTaxonomies
```

### Updating the warning lists…
```
$CAKE Admin updateWarningLists
```

### Updating the notice lists…
```
sudo $CAKE Admin updateNoticeLists
curl --header "Authorization: $AUTH_KEY" --header "Accept: application/json" --header "Content-Type: application/json" -k -X POST https://127.0.0.1/noticelists/update
```

### Updating the object templates…
```
sudo $CAKE Admin updateObjectTemplates
curl --header "Authorization: $AUTH_KEY" --header "Accept: application/json" --header "Content-Type: application/json" -k -X POST https://127.0.0.1/objectTemplates/update
```

### Add the following lines before the last line (exit 0). Make sure that you replace www-data with your apache user(I did not need)
```
sed -i -e '$i \echo never > /sys/kernel/mm/transparent_hugepage/enabled\n' /etc/rc.local
sed -i -e '$i \echo 1024 > /proc/sys/net/core/somaxconn\n' /etc/rc.local
sed -i -e '$i \sysctl vm.overcommit_memory=1\n' /etc/rc.local
sed -i -e '$i \sudo -u www-data bash /var/www/MISP/app/Console/worker/start.sh\n' /etc/rc.local
sed -i -e '$i \sudo -u www-data misp-modules -l 0.0.0.0 -s &\n' /etc/rc.local
```

### Start the workers
```
sudo -u www-data bash $PATH_TO_MISP/app/Console/worker/start.sh
```

### Install MISP modules

```
cd /usr/local/src/
git clone https://github.com/MISP/misp-modules.git
cd misp-modules
```
#### pip3 install
```
pip3 install -I -r REQUIREMENTS
pip3 install -I .
pip3 install maec lief python-magic wand yara
pip3 install git+https://github.com/kbandla/pydeep.git
```
#### install STIX2.0 library to support STIX 2.0 export:
```
pip3 install stix2
gem install pygments.rb
gem install asciidoctor-pdf --pre
```

### Once done, have a look at the diagnostics

### If any of the directories that MISP uses to store files is not writeable to the apache user, change the permissions
### You can do this by running the following commands:

```
chmod -R 750 $PATH_TO_MISP/<directory path with an indicated issue>
chown -R www-data:www-data $PATH_TO_MISP/<directory path with an indicated issue>
```

### Make sure that the STIX libraries and GnuPG work as intended, if not, refer to INSTALL.txt's paragraphs dealing with these two items

### If anything goes wrong, make sure that you check MISP's logs for errors:
```
$PATH_TO_MISP/app/tmp/logs/error.log
$PATH_TO_MISP/app/tmp/logs/resque-worker-error.log
$PATH_TO_MISP/app/tmp/logs/resque-scheduler-error.log
$PATH_TO_MISP/app/tmp/logs/resque-2015-01-01.log // where the actual date is the current date
```

```
echo "Admin (root) DB Password: $DBPASSWORD_ADMIN"
echo "User  (misp) DB Password: $DBPASSWORD_MISP"
```

Recommended actions
-------------------
- By default CakePHP exposes its name and version in email headers. Apply a patch to remove this behavior.

- You should really harden your OS
- You should really harden the configuration of Apache
- You should really harden the configuration of MySQL/MariaDB
- Keep your software up2date (OS, MISP, CakePHP and everything else)
- Log and audit


Optional features
-------------------
### MISP has a new pub/sub feature, using ZeroMQ. To enable it, simply run the following commands

### ZeroMQ depends on the Python client for Redis
```
pip3 install redis
```

### Install pyzmq
```
pip3 install pyzmq
```

MISP Dashboard
--------------

```
cd /var/www
mkdir misp-dashboard
chown www-data:www-data misp-dashboard
sudo -u www-data git clone https://github.com/MISP/misp-dashboard.git
cd misp-dashboard
/var/www/misp-dashboard/install_dependencies.sh
sed -i "s/^host\ =\ localhost/host\ =\ 0.0.0.0/g" /var/www/misp-dashboard/config/config.cfg
sed -i -e '$i \sudo -u www-data bash /var/www/misp-dashboard/start_all.sh\n' /etc/rc.local
sed -i '/Listen 80/a Listen 0.0.0.0:8001' /etc/apache2/ports.conf
apt install libapache2-mod-wsgi-py3
```

```
echo "<VirtualHost *:8001>
    ServerAdmin admin@misp.local
    ServerName misp.local
    DocumentRoot /var/www/misp-dashboard

    WSGIDaemonProcess misp-dashboard \
       user=misp group=misp \
       python-home=/var/www/misp-dashboard/DASHENV \
       processes=1 \
       threads=15 \
       maximum-requests=5000 \
       listen-backlog=100 \
       queue-timeout=45 \
       socket-timeout=60 \
       connect-timeout=15 \
       request-timeout=60 \
       inactivity-timeout=0 \
       deadlock-timeout=60 \
       graceful-timeout=15 \
       eviction-timeout=0 \
       shutdown-timeout=5 \
       send-buffer-size=0 \
       receive-buffer-size=0 \
       header-buffer-size=0 \
       response-buffer-size=0 \
       server-metrics=Off
    WSGIScriptAlias / /var/www/misp-dashboard/misp-dashboard.wsgi
    <Directory /var/www/misp-dashboard>
        WSGIProcessGroup misp-dashboard
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
    </Directory>
    LogLevel info
    ErrorLog /var/log/apache2/misp-dashboard.local_error.log
    CustomLog /var/log/apache2/misp-dashboard.local_access.log combined
    ServerSignature Off
</VirtualHost>" | sudo tee /etc/apache2/sites-available/misp-dashboard.conf
```

```
a2ensite misp-dashboard
```


### Enable ZeroMQ for misp-dashboard
```
$CAKE Admin setSetting "Plugin.ZeroMQ_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_event_notifications_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_object_notifications_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_object_reference_notifications_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_attribute_notifications_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_sighting_notifications_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_user_notifications_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_organisation_notifications_enable" true
$CAKE Admin setSetting "Plugin.ZeroMQ_port" 50000
$CAKE Admin setSetting "Plugin.ZeroMQ_redis_host" "localhost"
$CAKE Admin setSetting "Plugin.ZeroMQ_redis_port" 6379
$CAKE Admin setSetting "Plugin.ZeroMQ_redis_database" 1
$CAKE Admin setSetting "Plugin.ZeroMQ_redis_namespace" "mispq"
$CAKE Admin setSetting "Plugin.ZeroMQ_include_attachments" false
$CAKE Admin setSetting "Plugin.ZeroMQ_tag_notifications_enable" false
$CAKE Admin setSetting "Plugin.ZeroMQ_audit_notifications_enable" false
```


Install viper framework
-----------------------

```
cd /usr/local/src/
apt-get install -y libssl-dev swig python3-ssdeep p7zip-full unrar-free sqlite python3-pyclamd exiftool radare2
pip3 install SQLAlchemy PrettyTable python-magic
git clone https://github.com/viper-framework/viper.git
cd viper
git submodule update --init --recursive
pip3 install -r requirements.txt
pip3 uninstall yara -y
/usr/local/src/viper/viper-cli -h
/usr/local/src/viper/viper-web -p 8888 -H 0.0.0.0 &
echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/src/viper"' |sudo tee /etc/environment
sed -i "s/^misp_url\ =/misp_url\ =\ http:\/\/localhost/g" ~/.viper/viper.conf
sed -i "s/^misp_key\ =/misp_key\ =\ $AUTH_KEY/g" ~/.viper/viper.conf
sqlite3 ~/.viper/admin.db 'UPDATE auth_user SET password="pbkdf2_sha256$100000$iXgEJh8hz7Cf$vfdDAwLX8tko1t0M1TLTtGlxERkNnltUnMhbv56wK/U="'
```



Install mail to misp
--------------------
```
cd /usr/local/src/
apt-get install -y cmake
git clone https://github.com/MISP/mail_to_misp.git
git clone git://github.com/stricaud/faup.git
cd faup
mkdir -p build
cd build
cmake .. && sudo make
make install
ldconfig
cd ../../
cd mail_to_misp
pip3 install -r requirements.txt
cp mail_to_misp_config.py-example mail_to_misp_config.py

sed -i "s/^misp_url\ =\ 'YOUR_MISP_URL'/misp_url\ =\ 'http:\/\/localhost'/g" /usr/local/src/mail_to_misp/mail_to_misp_config.py
sed -i "s/^misp_key\ =\ 'YOUR_KEY_HERE'/misp_key\ =\ '$AUTH_KEY'/g" /usr/local/src/mail_to_misp/mail_to_misp_config.py
```