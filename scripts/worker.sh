# Set default version
VERSION=${VERSION:-"1.26.4"}

# Useful libs
sudo snap install yq

# Make some useful operations
(
sudo apt-get install python -y
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo 'disable swap'
sudo swapoff -a
grep -qxF 'nameserver 8.8.8.8' /etc/resolv.conf || echo 'nameserver 8.8.8.8' | sudo tee -a /etc/resolv.conf
grep -qxF 'nameserver 1.1.1.1' /etc/resolv.conf || echo 'nameserver 1.1.1.1' | sudo tee -a /etc/resolv.conf
) 1>/dev/null 2>&1 || true

# Disable apt daily stuff at it can definitely break something
(
echo 'disable apt daily stuff'
sudo systemctl stop apt-daily.timer
sudo systemctl disable apt-daily.timer
sudo systemctl mask apt-daily.service
sudo systemctl stop apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl mask apt-daily-upgrade.service
echo 'daemon reload'
sudo systemctl daemon-reload
) 1>/dev/null 2>&1 || true

# Cleanup first
echo 'cleaning up kube deps'
sudo kubeadm reset -f || true
sudo apt-mark unhold kubelet kubeadm kubectl || true
sudo apt-get remove -y containerd kubelet kubeadm kubectl kubernetes-cni || true
sudo apt-get autoremove -y
sudo systemctl daemon-reload

# Couples of prerequisites
sudo apt-get update -y
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo modprobe overlay
sudo modprobe br_netfilter

# NFS client
sudo apt-get install nfs-common -y

# Installing packages
sudo apt-get update -y
sudo apt-get install apt-transport-https nano curl -y
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update -y
sudo apt-get install -y kubelet=${VERSION}-00 kubeadm=${VERSION}-00 kubectl=${VERSION}-00 kubernetes-cni
sudo apt-mark hold kubelet kubeadm kubectl

# Installing Containerd
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install containerd.io -y

# Create containerd configuration
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
# sudo nano /etc/containerd/config.toml set SystemdCgroup = true
sudo systemctl restart containerd

# Configure crictl to use Containerd (it uses Docker by default)
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
EOF

# Install nerdctl
ARCH=$(dpkg --print-architecture)
NERDCTL_VERSION=0.17.0
wget -q https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${ARCH}.tar.gz
sudo tar Cxzvvf /usr/local/bin nerdctl-${NERDCTL_VERSION}-linux-${ARCH}.tar.gz
rm nerdctl-${NERDCTL_VERSION}-linux-${ARCH}.tar.gz
