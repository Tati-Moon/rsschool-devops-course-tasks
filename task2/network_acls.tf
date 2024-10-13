
# Public Subnet Network ACL
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.my_project_vpc.id
  tags = {
    Name = "Public Subnet NACL"
  }
}

# Inbound rules for Public Subnets
resource "aws_network_acl_rule" "allow_http_inbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"  # Corrected rule_action attribute
}

resource "aws_network_acl_rule" "allow_https_inbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 101
  egress         = false
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"  # Corrected rule_action attribute
}

resource "aws_network_acl_rule" "allow_ssh_inbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 102
  egress         = false
  protocol       = "tcp"
  from_port      = 22
  to_port        = 22
  cidr_block     = var.allowed_ip_cidr
  rule_action    = "allow"  # Corrected rule_action attribute
}

# Outbound rule to allow all traffic from public subnets
resource "aws_network_acl_rule" "allow_all_outbound_public" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"  # Corrected rule_action attribute
}

# Private Subnet Network ACL
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.my_project_vpc.id
  tags = {
    Name = "Private Subnet NACL"
  }
}

# Inbound rules for Private Subnets - allow traffic from public subnet (for example SSH)
resource "aws_network_acl_rule" "allow_ssh_inbound_private" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  from_port      = 22
  to_port        = 22
  cidr_block     = element(var.public_subnet_cidrs, 0)
  rule_action    = "allow"  # Corrected rule_action attribute
}

# Outbound rule to allow all traffic to the NAT Gateway
resource "aws_network_acl_rule" "allow_all_outbound_private" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"  # Corrected rule_action attribute
}
