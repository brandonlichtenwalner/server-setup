#!/bin/bash
# setup-common.sh
# setup configs & install packages common to bare metal and virtual installs

# Check which type of system we're on and act appropriately
case $(lsb_release -ds) in
  *"Ubuntu 18.04"*)
    # Proceed for Ubuntu 18.04
    echo "Ubuntu 18.04 test"
    ;;
  *"CentOS Linux release 7"*)
    # Proceed for CentOS 7
    echo "CentOS 7 test"
    ;;
  *)
    # Default case
    echo "No actions defined for $(lsb_release -ds)"
    ;;
esac
