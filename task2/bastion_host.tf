resource "aws_instance" "bastion_host" {
  ami           = var.ec2_ami_amazon_linux  # Use a variable for the AMI ID
  instance_type = "t2.micro"                # Specify the instance type
  subnet_id     = aws_subnet.public_subnet[0].id  # Place in the first public subnet
  
  # Ensure the security group allows SSH access only from known IP addresses
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  key_name = var.ssh_key_name  # Optionally, specify a key pair name for SSH access

  tags = {
    Name = "Bastion Host"
    Environment = "Development"
  }
}