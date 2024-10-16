resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id = aws_vpc.my_project_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  // Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  // Allow all outbound traffic
  }

  tags = {
    Name = "Bastion Security Group"
  }
}


resource "aws_security_group" "private_instance" {
  name        = "private-instance-sg"
  description = "Security group for private instance"
  vpc_id = aws_vpc.my_project_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = [var.allowed_ip_cidr]
    description     = "Allow SSH from bastion-host."
  }

  ingress {
    from_port       = 8
    to_port         = 0
    protocol        = "icmp"
    cidr_blocks = [var.allowed_ip_cidr]
    description     = "Allow ICMP echo from bastion-host and public instances."
  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
   cidr_blocks = [var.allowed_ip_cidr]
    description     = "Allow all TCP traffic from public instances"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all traffic between instances with this security group."
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Anywhere."
  }

  tags = {
      Name = "private-instance"
    }
}