resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.my_project_vpc.id

  // Ingress rule allowing SSH from a specific IP range
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_cidr]  # Variable for allowed IP addresses
  }

  // Egress rule allowing all outbound traffic
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