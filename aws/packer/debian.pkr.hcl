packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "project_name" {
  type    = string
  default = "debian-server"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "debian_version" {
  type    = string
  default = "13"
}

variable "debian_mirror" {
  type    = string
  default = "http://deb.debian.org/debian"
}

variable "aws_source_ami" {
  type    = string
  default = ""
  description = "Optional: Specify a source AMI. If empty, will search for latest Debian AMI"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

data "amazon-ami" "debian" {
  filters = {
    name                = "debian-13-amd64-2025*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["136693071363"] # Debian official AWS account
  region      = var.aws_region
}

source "amazon-ebs" "debian" {
  region                  = var.aws_region
  source_ami              = var.aws_source_ami != "" ? var.aws_source_ami : data.amazon-ami.debian.id
  instance_type           = var.instance_type
  ssh_username            = "admin"
  ssh_keypair_name        = ""
  ssh_private_key_file    = ""
  ami_name                = "${var.project_name}-${var.environment}-${local.timestamp}"
  ami_description         = "Debian ${var.debian_version} server image for ${var.project_name} - ${var.environment}"
  ami_virtualization_type = "hvm"
  encrypt_boot            = false

  run_tags = {
    Name        = "${var.project_name}-packer-builder"
    Environment = var.environment
    ManagedBy   = "packer"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    OS          = "Debian ${var.debian_version}"
    ManagedBy   = "packer"
    Version     = local.timestamp
  }

  snapshot_tags = {
    Name        = "${var.project_name}-${var.environment}-snapshot"
    Environment = var.environment
    ManagedBy   = "packer"
  }

  run_volume_tags = {
    Name        = "${var.project_name}-${var.environment}-root"
    Environment = var.environment
    ManagedBy   = "packer"
  }
}

build {
  sources = ["source.amazon-ebs.debian"]

  provisioner "shell" {
    execute_command = "echo 'admin' | sudo -S -E bash '{{.Path}}'"
    inline = [
      "apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io",
      "systemctl enable docker",
      "usermod -aG docker admin",
      "curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      "apt-get install -y git curl wget vim htop nano jq unzip software-properties-common",
      "apt-get install -y python3 python3-pip python3-venv",
      "apt-get install -y nginx",
      "systemctl enable nginx",
      "systemctl stop nginx",
      "rm -rf /var/lib/apt/lists/*",
      "echo 'Defaults:admin !requiretty' >> /etc/sudoers",
      "echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
    ]
  }

  provisioner "shell" {
    execute_command = "echo 'admin' | sudo -S -E bash '{{.Path}}'"
    script          = "scripts/setup-users.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'admin' | sudo -S -E bash '{{.Path}}'"
    script          = "scripts/cleanup.sh"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
    custom_data = {
      project_name   = var.project_name
      environment    = var.environment
      debian_version = var.debian_version
      build_date     = timestamp()
    }
  }
}
