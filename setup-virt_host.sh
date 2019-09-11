#!/bin/bash
# setup-virt_host.sh
apt install bridge-utils libguestfs-tools libvirt-bin qemu-kvm virtinst zfsutils-linux

# enable nested virtualization
echo 'options kvm_intel nested=1' >> /etc/modprobe.d/qemu-system-x86.conf

# enable/start the libvirt service
systemctl enable --now libvirtd

# TODO: netplan bridge configuration -- see kvm-c
# TODO: ZFS pool creation? probably needs to be manual. ALWAYS via /dev/disk/by-id
#       and also `zfs set compression=lz4 <poolname>` after pool is created

# Manual zpool creation
# Use Brandon's `llblk` alias to get S/N of disks, then `ls /dev/disk/by-id/` to identify them
# The commands will look like this (from kvm-a):
#   zpool create evo860pool_kvm-a -m /var/lib/libvirt/images mirror /dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z8NB0M321273B /dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z8NB0M321275T mirror /dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z8NB0M321284K /dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z8NB0M351390K
#   zfs set compression=lz4 evo860pool_kvm-a
