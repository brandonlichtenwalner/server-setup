#!/bin/bash
# setup-redmine.sh
# adapted from https://www.hiroom2.com/2019/06/17/ubuntu-1904-redmine-en/


# Make sure the script has been executed as root
if [ "$USER" != 'root' ]; then
        echo "This script must be run with root privileges."
        echo "Try using: sudo $0 $@"
        exit 2
fi


echo "This script is interactive and will require input for database passwords, etc."
echo "---"
echo ""


# Install PostgreSQL
apt -y install postgresql


# Install Redmine with Postgres plugin
apt -y install redmine-pgsql


# Install Bundler and Apache with Passenger
apt install -y apache2 bundler libapache2-mod-passenger

## Overwrite passenger.conf with configuration for redmine
cat << EOF | sudo tee /etc/apache2/mods-available/passenger.conf
<IfModule mod_passenger.c>
  PassengerRoot /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini
  PassengerDefaultRuby /usr/bin/ruby
  PassengerDefaultUser www-data
  RailsBaseURI /redmine
</IfModule>
EOF

## Create directories and Apache configuration for Redmine
cd /var/www/html
ln -s /usr/share/redmine/public redmine
chown -R www-data:www-data /usr/share/redmine
cat << EOF | sudo tee /etc/apache2/sites-available/redmine.conf
<VirtualHost _default_:443>
  SSLEngine on
  SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
  SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

  <Directory /redmine>
    Options FollowSymLinks
    PassengerResolveSymlinksInDocumentRoot on
    AllowOverride None
  </Directory>
</VirtualHost>
EOF

## Enable Apache modules for Redmine
a2enmod passenger
a2enmod ssl
a2ensite redmine

## Enable and restart Apache
systemctl enable apache2
systemctl restart apache2
