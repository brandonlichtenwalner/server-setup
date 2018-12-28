#!/bin/bash
# setup-common.sh
# setup configs & install packages common to bare metal and virtual installs

# Check which type of system we're on and act appropriately
if lsb_release -ds | grep -o "Ubuntu 18.04" >/dev/null 2>&1; then
  # Proceed for Ubuntu 18.04
elif lsb_release -ds | grep -o "CentOS Linux release 7" >/dev/null 2>&1; then
  # Proceed for CentOS 7
else
  echo "No actions defined for $(lsb_release -ds)"
fi
