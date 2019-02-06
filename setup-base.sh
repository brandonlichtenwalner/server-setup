#!/bin/bash
# setup-common.sh
# setup configs & install packages common to bare metal and virtual installs


# Make sure the script has been executed as root
if [ "$USER" != 'root' ]; then
        echo "This script must be run with root privileges."
        echo "Try using: sudo $0 $@"
        exit 2
fi



### Items that apply to all (common) Linux distributions

hostname=read -p "Hostname:  "
hostnamectl set-hostname $hostname


# Define personal aliases and add to /etc/bash.bashrc to add for all users
alias llblk="lsblk --output NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,SERIAL,UUID"
cat <<EOT >> /etc/bash.bashrc

# Alias for long listing of block devices
alias llblk="lsblk --output NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,SERIAL,UUID"
EOT


# Add public key for Brandon after making sure the appropriate directory exists
mkdir -p /home/brandon/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcLjkMBCaRdjp5ePpbuOYoBHIZKdaRU2IAp8ce5wD82xZBA9Y2Rgo5HWFX38YP7XQuij++fBMnuwCDE6vCZ8TX5Lnd8qpvNQxBBBigADOXxjU4Qp3m/BuU1T4F82enXGjGhZI50C4JbJaMkuAihXdF5dso2fVvBmYbUiqMdEnPcN2/3vDUPoU2N7h3B1s30CCeVeaieP7AT6n0z7lCG8Pcn25E+f/0xNg0bGKjkEln9mn3ctDIPe0oUBlVd5PX7dRiS6qNduM3OjAy8SDUooUeP2Kigr/hXWrGHnwUL6BOuzQS5Dhd47MSuyH/bgBFRuBFJKeiY5Si0fMlRDzZuCMYD5s/QR+Juw/ATAyKh08VHSQUBmvrgJ3k5r/v9s/DgYUCPFH1vADnEnqfP/DvCKrZLVoR2DtPDUibjsmJsBSwQ7MDpMJxm8UFYzs+J/ZF1rjlglcU1WnS9KBxz6MX/gdqOKfXDcTanGlK6BDGF1oxZ4wRRuphO/ZQtHtkZNVGMbTSwjrYnFIJ/hqPNUtnj1osifGaINUJqLyWNRGC+7s87ZWCkdpOHdEz2FCiBtfOmDVVkcwIo+XMmfePNYqbp+te2PFrflzlmZlWPRuIP+gdP44soGZlxqCUSdALXuSpHb5WlQdRb/0YzkMU2rN8ne3Q2w7z8aZFTQnj+lBjtP+7LQ== ThinkPad_W550s_UMBCTC" >> /home/brandon/.ssh/authorized_keys


# Make sure SSH directory ownership and permissions are set correctly
chown -R brandon:brandon /home/brandon/.ssh
chmod -R go-rwx /home/brandon/.ssh



### Check which type of system we're on and act appropriately
case $(lsb_release -ds) in
  *"Ubuntu 18.04"*)
    # Proceed for Ubuntu 18.04

    # add additional repositories
    cat <<-'    EOT' >> /etc/apt/sources.list

    deb http://archive.ubuntu.com/ubuntu bionic universe multiverse

    deb http://us.archive.ubuntu.com/ubuntu/ bionic universe
    deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates universe

    deb http://us.archive.ubuntu.com/ubuntu/ bionic multiverse
    deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates multiverse

    deb http://security.ubuntu.com/ubuntu bionic-security universe
    deb http://security.ubuntu.com/ubuntu bionic-security multiverse
    EOT

    echo "Updating system..."
    apt update
    apt -y full-upgrade

    echo "Installing common packages..."
    sudo apt -y install fail2ban

    echo "Cleaning up..."
    sudo apt -y autoremove
    sudo apt -y clean
    ;;

  *"CentOS Linux release 7"*)
    # Proceed for CentOS 7
    echo "CentOS 7 test"
    ;;

  *)
    # Default case
    echo "WARNING: No actions defined for $(lsb_release -ds). Processing default actions only."
    ;;
esac



### Additional configuration after system-specific installs
cat << EOF > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 192.168.168.50/28
EOF
