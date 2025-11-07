#!/bin/bash

# Update system packages
echo "Updating system packages..."
apt-get update -y
apt-get upgrade -y

# Install required packages for Docker
echo "Installing required packages..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    git \
    build-essential \
    jq

# Add Docker's official GPG key
echo "Adding Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "Installing Docker Engine..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add ubuntu user to docker group
echo "Adding ubuntu user to docker group..."
usermod -aG docker ubuntu

# Enable and start Docker service
echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

# Install Docker Compose
echo "Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install additional development tools
echo "Installing additional development tools..."
apt-get install -y \
    vim \
    tmux \
    htop \
    tree \
    unzip \
    zip \
    wget \
    curl

# Configure Docker daemon
echo "Configuring Docker daemon..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "live-restore": true,
  "userland-proxy": false
}
EOF

# Restart Docker to apply configuration
systemctl restart docker

# Create workspace directory for Docker builds
echo "Creating workspace directory..."
mkdir -p /home/ubuntu/workspace
chown ubuntu:ubuntu /home/ubuntu/workspace

# Display Docker installation information
echo "================================================"
echo "Docker Installation Complete!"
echo "================================================"
echo "Docker version: $(docker version --format '{{.Server.Version}}')"
echo "Docker Compose version: $(docker-compose version)"
echo "Docker user group added for: ubuntu"
echo ""
echo "You can now:"
echo "1. SSH to the instance and run 'docker --version' to verify"
echo "2. Use 'docker' and 'docker-compose' commands"
echo "3. Build Docker images directly on this instance"
echo "4. The workspace directory is at: /home/ubuntu/workspace"
echo ""
echo "Note: You may need to log out and back in for the docker group changes to take effect"
echo "================================================"