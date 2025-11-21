# Security Group Module

resource "aws_security_group" "main" {
  name        = "${var.name}-sg"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name      = "${var.name}-sg"
      ManagedBy = "terraform"
    },
    var.tags
  )
}

# SSH Ingress Rule
resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_allowed_cidrs
  description       = "Allow SSH access"
  security_group_id = aws_security_group.main.id
}

# Default Egress Rule - Allow all outbound
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.main.id
}

# Additional ingress rules
resource "aws_security_group_rule" "additional_ingress" {
  for_each = { for idx, rule in var.additional_ingress_rules : idx => rule }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  security_group_id = aws_security_group.main.id
}
