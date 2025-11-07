#!/bin/bash
# Cleanup script to prepare the image for production

set -e

echo "Starting cleanup process..."

# Remove cloud-init artifacts
rm -rf /var/lib/cloud/instances/*

# Clean up temporary files
rm -rf /tmp/*
rm -rf /var/tmp/*

# Clean package manager cache
apt-get clean
apt-get autoremove -y
apt-get autoclean

# Remove old kernels except the current one
dpkg --list | grep linux-image | awk '{print $2}' | grep -v $(uname -r) | xargs apt-get purge -y

# Remove old kernel headers
dpkg --list | grep linux-headers | awk '{print $2}' | grep -v $(uname -r) | xargs apt-get purge -y

# Clean up documentation
rm -rf /usr/share/doc/*
rm -rf /usr/share/man/*
rm -rf /usr/share/info/*
rm -rf /usr/share/doc-base/*

# Clean up local files
rm -rf /root/.cache
rm -rf /root/.glide
rm -rf /root/.go
rm -rf /root/.cargo

# Remove bash history
rm -f /root/.bash_history
rm -f /home/*/.bash_history
rm -f /home/*/.python_history
history -c

# Remove SSH host keys (will be regenerated on first boot)
rm -f /etc/ssh/ssh_host_*
rm -f /home/*/.ssh/known_hosts

# Clean up systemd journal
journalctl --vacuum-time=1d

# Remove machine-id (will be generated on first boot)
if [ -f /etc/machine-id ]; then
    truncate -s 0 /etc/machine-id
fi

# Remove hostname (will be set on first boot)
if [ -f /etc/hostname ]; then
    echo "localhost" > /etc/hostname
fi

# Clean up log files but keep the directory structure
find /var/log -type f -name "*.log" -delete
find /var/log -type f -name "*.out" -delete

# Remove swap file if it exists
if [ -f /swapfile ]; then
    swapoff /swapfile
    rm -f /swapfile
fi

# Clean up package manager databases
rm -f /var/lib/dpkg/status-old
rm -f /var/lib/apt/lists/*_old
rm -f /var/cache/apt/pkgcache.bin
rm -f /var/cache/apt/srcpkgcache.bin

# Remove build-essential and related packages if not needed
apt-get purge -y build-essential linux-headers-$(uname-r) pkg-config

# Clean up Python cache files
find / -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find / -type f -name "*.pyc" -delete 2>/dev/null || true
find / -type f -name "*.pyo" -delete 2>/dev/null || true

# Set timezone to UTC
timedatectl set-timezone UTC

# Disable password authentication for all users except root
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Clear any existing network configuration
echo "" > /etc/network/interfaces.d/50-cloud-init.cfg

# Remove cloud-init network configuration
rm -f /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

# Force password change on first login for admin user
passwd -l admin

echo "Cleanup process completed successfully"

# Display final disk usage
echo "Final disk usage:"
df -h /