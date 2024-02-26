#!/bin/sh

# This script is used to kill a VM on Proxmox

qm unlock $1
ls -l /run/lock/qemu-server
rm -f /run/lock/qemu-server/lock-$1.conf
qm unlock $1
ls -l /run/lock/qemu-server
qm stop $1 && qm status $1
