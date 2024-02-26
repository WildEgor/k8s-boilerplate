#!/bin/bash

sudo apt install openssh-client -y &&
  sudo apt install openssh-server -y &&
  sudo systemctl enable ssh &&
  sudo ufw allow ssh &&
  sudo systemctl restart ssh 

echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/01-permitroot.conf &&
sudo service sshd restart &&
sudo service ssh restart

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''