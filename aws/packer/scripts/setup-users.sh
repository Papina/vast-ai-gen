#!/bin/bash
# Setup users and configure system for production use

set -e

echo "Setting up users and system configuration..."

# Create additional user accounts
if id "deploy" >/dev/null 2>&1; then
    echo "User 'deploy' already exists"
else
    useradd -m -s /bin/bash deploy
    usermod -aG sudo,docker deploy
    echo "deploy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    echo "Created user 'deploy'"
fi

# Setup SSH configuration
mkdir -p /home/admin/.ssh
mkdir -p /home/deploy/.ssh
chmod 700 /home/admin/.ssh
chmod 700 /home/deploy/.ssh

# Copy authorized keys from root
if [ -f /root/.ssh/authorized_keys ]; then
    cp /root/.ssh/authorized_keys /home/admin/.ssh/authorized_keys
    chmod 600 /home/admin/.ssh/authorized_keys
    chown -R admin:admin /home/admin/.ssh
fi

# Configure SSH server
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service
systemctl restart sshd

# Configure log rotation
cat > /etc/logrotate.d/app << EOF
/var/log/app/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 root root
    postrotate
        systemctl reload rsyslog
    endscript
}
EOF

# Setup monitoring and health check endpoints
mkdir -p /var/log/app

# Create a simple health check script
cat > /usr/local/bin/health-check.sh << 'EOF'
#!/bin/bash
# Simple health check script for load balancers

STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2

# Check if services are running
if systemctl is-active --quiet nginx; then
    echo "nginx: running"
else
    echo "nginx: stopped"
    exit $STATUS_CRITICAL
fi

if systemctl is-active --quiet docker; then
    echo "docker: running"
else
    echo "docker: stopped"
    exit $STATUS_CRITICAL
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "disk usage: ${DISK_USAGE}% - critical"
    exit $STATUS_CRITICAL
elif [ "$DISK_USAGE" -gt 80 ]; then
    echo "disk usage: ${DISK_USAGE}% - warning"
    exit $STATUS_WARNING
else
    echo "disk usage: ${DISK_USAGE}% - ok"
fi

# Check memory usage
MEM_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ "$MEM_USAGE" -gt 90 ]; then
    echo "memory usage: ${MEM_USAGE}% - critical"
    exit $STATUS_CRITICAL
elif [ "$MEM_USAGE" -gt 80 ]; then
    echo "memory usage: ${MEM_USAGE}% - warning"
    exit $STATUS_WARNING
else
    echo "memory usage: ${MEM_USAGE}% - ok"
fi

echo "All checks passed"
exit $STATUS_OK
EOF

chmod +x /usr/local/bin/health-check.sh

# Create systemd service for health checks
cat > /etc/systemd/system/health-check.service << EOF
[Unit]
Description=Health Check Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/health-check.sh
User=root
EOF

# Create timer for periodic health checks
cat > /etc/systemd/system/health-check.timer << EOF
[Unit]
Description=Run health checks every 5 minutes
Requires=health-check.service

[Timer]
OnCalendar=*:0/5
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable health-check.timer

# Setup automatic security updates
cat > /etc/apt/apt.conf.d/50unattended-upgrades << EOF
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security";
    "\${distro_id}ESMApps:\${distro_codename}-apps-security";
    "\${distro_id}ESM:\${distro_codename}-infra-security";
};

Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::SyslogEnable "true";
Unattended-Upgrade::SyslogFacility "daemon";
EOF

cat > /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

echo "User and system setup completed successfully"