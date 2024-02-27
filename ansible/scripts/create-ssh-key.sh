#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

# Get the IP address from the [proxmox] section
export ANSIBLE_HOST_IP=$(awk '/\[host\]/{getline; print $1}' ../hosts)

# Check if the IP address is not empty
if [ -n "$ANSIBLE_HOST_IP" ]; then
    # Generate SSH key
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N '' -C "" -q

    # Copy the public key to the remote server
    ssh-copy-id -i ~/.ssh/id_rsa.pub root@"$ANSIBLE_HOST_IP"

    echo "SSH key generation and copy completed."
else
    echo "Error: Unable to extract IP address from hosts."
    exit 1
fi
