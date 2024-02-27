#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

# Get the IP address from the [proxmox] section
export ANSIBLE_HOST_IP=$(awk '/\[proxmox\]/{getline; print $1}' hosts.txt)
export ANSIBLE_HOST_PASSWORD=$(grep 'ansible_pass' hosts.txt | awk -F= '{print $2}' | tr -d '[:space:]')

# Check if the IP address is not empty
if [ -n "$ANSIBLE_HOST_IP" ]; then
    # Generate SSH key
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N '' -C "" -q

    # Copy the public key to the remote server
    sshpass -p $ANSIBLE_HOST_PASSWORD ssh-copy-id -i ~/.ssh/id_rsa.pub root@"$ANSIBLE_HOST_IP"

    echo "SSH key generation and copy completed."
else
    echo "Error: Unable to extract IP address from hosts.txt."
    exit 1
fi

ansible -i hosts.txt proxmox -u root -m ping

ansible-playbook -i hosts.txt create-vm-template.yml
