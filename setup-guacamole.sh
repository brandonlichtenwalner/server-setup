#!/bin/bash

# Set up Apache Guacamole server

# Written for Guacamole 1.0.0 on Ubuntu 18.04
GUACVERSION=1.0.0
TOMCATVERSION=9

# Get the files and check integrity
wget http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/$GUACVERSION/binary/guacamole-$GUACVERSION.war
wget https://www.apache.org/dist/guacamole/$GUACVERSION/binary/guacamole-$GUACVERSION.war.sha256

sha256sum -c guacamole-$GUACVERSION.war.sha256
if [ $? != 0 ]; then
  echo "ERROR: guacamole-$GUACVERSION.war checksum is not valid!"
  exit 1
fi

wget http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/$GUACVERSION/source/guacamole-server-$GUACVERSION.tar.gz
https://www.apache.org/dist/guacamole/1.0.0/source/guacamole-client-$GUACVERSION.tar.gz.sha256

sha256sum -c guacamole-$GUACVERSION.tar.gz.sha256
if [ $? != 0 ]; then
  echo "ERROR: guacamole-$GUACVERSION.tar.gz checksum is not valid!"
  exit 1
fi


# Update packages and install build environment
sudo apt -y update
sudo apt -y install gcc-6 g++-6

# Install required dependencies
sudo apt -y install libcairo2-dev libjpeg-turbo8-dev libjpeg62-dev libpng12-dev libossp-uuid-dev

# Install optional dependencies
sudo apt -y install libfreerdp-dev libpango-1.0-dev libssh2-1-dev libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev

# Install Tomcat
sudo apt -y install tomcat$TOMCATVERSION tomcat$TOMCATVERSION-admin tomcat$TOMCATVERSION-user

# Copy the .war file to the appropriate directory
sudo cp guacamole-$GUACVERSION.war /var/lib/tomcat/webapps/guacamole.war

# Restart tomcat to find the new file
sudo systemctl restart tomcat

# Build guacamole-server
tar zxvf guacamole-server-$GUACVERSION.tar.gz
cd guacamole-server-$GUACVERSION.tar.gz

./configure --with-init-dir=/etc/init.d
make CC=gcc-6
sudo make install

# Run ldconfig to create the necessary links and cahce to the most recent shared libraries
sudo ldconfig

# enable/start guacd service
sudo systemctl enable --now guacd
