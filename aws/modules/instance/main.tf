# Instance Module for AWS

# Create Key Pair
resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name        = "${var.project_name}-keypair"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Launch Instances
resource "aws_instance" "main" {
  count = var.instance_count

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids
  key_name              = aws_key_pair.main.key_name
  iam_instance_profile  = var.iam_instance_profile
  user_data             = var.user_data

  # Root volume
  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
    encrypted   = var.encrypt_root_volume
    kms_key_id  = var.kms_key_id
  }

  # Additional volumes
  dynamic "ebs_block_device" {
    for_each = var.additional_volumes
    content {
      device_name = ebs_block_device.value.device_name
      volume_type = ebs_block_device.value.volume_type
      volume_size = ebs_block_device.value.volume_size
      encrypted   = ebs_block_device.value.encrypted
      kms_key_id  = ebs_block_device.value.kms_key_id
    }
  }

  # Network interfaces
  network_interface {
    network_interface_id = var.network_interface_id
    device_index         = 0
  }

  tags = {
    Name        = "${var.project_name}-instance-${count.index + 1}"
    Environment = var.environment
    Purpose     = var.purpose
    ManagedBy   = "terraform"
  }

  # Tags for additional volumes
  dynamic "tag" {
    for_each = var.additional_volumes
    content {
      key                 = "Name"
      value              = "${var.project_name}-${tag.value.device_name}-${count.index + 1}"
      propagate_at_launch = false
    }
  }

  depends_on = [aws_key_pair.main]
}