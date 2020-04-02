#!/bin/bash
# setup-syncthing.sh


# Make sure the script has been executed as root
if [ "$USER" != 'root' ]; then
        echo "This script must be run with root privileges."
        echo "Try using: sudo $0 $@"
        exit 2
fi

# Install Syncthing snap
snap install syncthing

# Download Syncthing service file for servers to default systemd folder
wget https://raw.githubusercontent.com/syncthing/syncthing/master/etc/linux-systemd/system/syncthing%40.service -P /etc/systemd/system

# Enable & start the Syncthing service
systemctl enable --now syncthing@brandon.service

echo "Finished executing $0"
