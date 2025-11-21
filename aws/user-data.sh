#!/bin/bash
set -e

# Update package list and install prerequisites
apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release

# Install Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable Docker service
systemctl enable docker

# Add admin user to docker group
usermod -aG docker admin

# Install essential tools
apt-get install -y git curl wget vim htop nano jq unzip software-properties-common

# Cleanup
rm -rf /var/lib/apt/lists/*

# Configure sudo for admin user
echo 'Defaults:admin !requiretty' >> /etc/sudoers
echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
