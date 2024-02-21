
Check disk info
```bash
sudo fdisk -l
```

Install gparted for partitioning
```bash
sudo apt install gparted
```

if disk read only
```bash
sudo mount -o remount,rw [path to disk, ex /dev/sda1]
```

### Run VMWare REST API server
```bash
cd [VMWare install path]
vmrest.exe -C
```
Authorize with creds and run
```bash
vmrest
```

