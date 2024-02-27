#!/bin/bash

apt install openssh-client -y &&
  apt install openssh-server -y &&
  systemctl enable ssh &&
  ufw allow ssh &&
  systemctl restart ssh

echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/01-permitroot.conf &&
service sshd restart &&
service ssh restart

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''
