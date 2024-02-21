Show listening ports
```bash
sudo lsof -i -P -n | grep LISTEN
```

Append to /etc/hosts file if not already present
```bash
HOST_ALIAS=$(hostname)
grep -qxF "127.0.0.1 $HOST_ALIAS" /etc/hosts || echo "127.0.0.1 $HOST_ALIAS" | sudo tee -a /etc/hosts
```

### Install SSH client and server
```bash
sudo apt install openssh-client \
  sudo apt install openssh-server \
  sudo systemctl enable ssh \
  sudo ufw allow ssh \
  sudo systemctl restart ssh \
  sudo systemctl status ssh \
```

Show ssh logs
```bash
  journalctl -u ssh
```

Make ssh passwordless (run on every node)
```bash
ssh-keygen -t rsa -b 4096 -C "
ssh-copy-id -i ~/.ssh/id_rsa.pub [user]@[host]
```
