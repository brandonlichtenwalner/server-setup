#!/bin/bash

# Set up Apache Guacamole server

# Written for Guacamole 1.0.0 on Ubuntu 18.04
GUACVERSION=1.0.0
TOMCATVERSION=9



# Get the files and check integrity
wget https://mirror.reverse.net/pub/apache/guacamole/$GUACVERSION/binary/guacamole-$GUACVERSION.war
wget https://www.apache.org/dist/guacamole/$GUACVERSION/binary/guacamole-$GUACVERSION.war.sha256

sha256sum -c guacamole-$GUACVERSION.war.sha256
if [ $? != 0 ]; then
  echo "ERROR: guacamole-$GUACVERSION.war checksum is not valid!"
  exit 1
fi

wget https://mirror.reverse.net/pub/apache/guacamole/$GUACVERSION/source/guacamole-server-$GUACVERSION.tar.gz
wget https://www.apache.org/dist/guacamole/1.0.0/source/guacamole-server-$GUACVERSION.tar.gz.sha256

sha256sum -c guacamole-server-$GUACVERSION.tar.gz.sha256
if [ $? != 0 ]; then
  echo "ERROR: guacamole-server-$GUACVERSION.tar.gz checksum is not valid!"
  exit 1
fi



# Update packages and install build environment, required packages, optional packages, and tomcat
# NOTE: libjpeg62-dev not installed due to conflict with libjpeg-turbo8-dev
# NOTE: optional screen recording packages not installed
sudo apt -y update
sudo apt -y install gcc-6 g++-6 \
libcairo2-dev libjpeg-turbo8-dev libpng-dev libossp-uuid-dev \
libfreerdp-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev \
tomcat$TOMCATVERSION tomcat$TOMCATVERSION-admin tomcat$TOMCATVERSION-user

if [ $? != 0 ]; then
  echo "ERROR: Required packages failed to install!"
  exit 1
fi



# Tomcat / guac-client configuration

## Copy the .war file to the appropriate directory
sudo cp guacamole-$GUACVERSION.war /var/lib/tomcat/webapps/guacamole.war

# Restart tomcat to load the .war file
sudo systemctl restart tomcat



# Build guacamole-server

tar zxvf guacamole-server-$GUACVERSION.tar.gz
cd guacamole-server-$GUACVERSION.tar.gz

./configure --with-init-dir=/etc/init.d
make CC=gcc-6
sudo make install

## Run ldconfig to create the necessary links and cahce to the most recent shared libraries
sudo ldconfig

## enable/start guacd service
sudo systemctl enable --now guacd



# TODO: configure (postgresql) database authentication
