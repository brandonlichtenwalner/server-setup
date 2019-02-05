#!/bin/bash
# setup-common.sh
# setup configs & install packages common to bare metal and virtual installs

### TODO: Add check for if the script is running as root



### Items that apply to all (common) Linux distributions

hostname=read -p "Hostname:  "
hostnamectl set-hostname $hostname

# Define personal aliases and add to /etc/bash.bashrc to add for all users
alias llblk="lsblk --output NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,SERIAL,UUID"
cat <<EOT >> /etc/bash.bashrc
# Alias for long listing of block devices
alias llblk="lsblk --output NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,SERIAL,UUID"
EOT



### Check which type of system we're on and act appropriately
case $(lsb_release -ds) in
  *"Ubuntu 18.04"*)
    # Proceed for Ubuntu 18.04
    echo "Installing common packages..."
    sudo apt install smartmontools
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
