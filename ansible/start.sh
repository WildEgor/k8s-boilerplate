#!/bin/bash

while true; do
    echo "Choose an option:"
    echo "1. Prepare Proxmox"
    echo "2. Create ssh keys"
    echo "3. Create vault"
    echo "4. Create VM template"
    echo "5. Create VMs"
    echo "6. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Prepare Proxmox"
            ansible-playbook -i /ansible/hosts /ansible/books/prep-host.yml
            ;;
        2)
            echo "Create ssh keys"
            export ANSIBLE_HOST_KEY_CHECKING=False

            # Get the IP address from the [proxmox] section
            export ANSIBLE_HOST_IP=$(awk '/\[host\]/{getline; print $1}' hosts)

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
            ;;
        3)
            echo "Create vault"
            # Enter the following content:
            # ---
            # vault_api_password: 'admin'
            # vault_100: 'admin'
            # vault_101: 'admin'

            ansible-vault create creds.yml
            ;;
        4)
            echo "Create VM template"
            ansible-playbook -i /ansible/hosts /ansible/books/create-vm-template.yml
            ;;
        5)
            echo "Create VMs"
            ansible-playbook -i /ansible/hosts /ansible/books/create-vms.yml
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a valid option."
            ;;
    esac
done