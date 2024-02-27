#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

# ssh-copy-id <proxmox ip>

ansible -i hosts.txt proxmox -u root -m ping

ansible-playbook -i hosts.txt create-vm-template.yml
