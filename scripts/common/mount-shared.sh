sudo apt install open-vm-tools open-vm-tools-desktop &&
sudo mkdir -p /mnt/hgfs &&
sudo mount -t fuse.vmhgfs-fuse .host:/shared /mnt/hgfs -o allow_other &&
grep -qxF '.host:/shared /mnt/hgfs fuse.vmhgfs-fuse auto,allow_other 0 0' /etc/fstab || echo '.host:/shared /mnt/hgfs fuse.vmhgfs-fuse auto,allow_other 0 0' | sudo tee -a /etc/fstab
