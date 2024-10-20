resource "aws_instance" "public_instances" {
  count = length(var.public_subnet_cidrs)

  ami           = var.ec2_ami_amazon_linux
  instance_type = "t2.micro"
  key_name      = var.ssh_key_name

  subnet_id                   =  element(aws_subnet.public_subnet[*].id, count.index)
  vpc_security_group_ids      = [aws_security_group.public_instance.id]
  associate_public_ip_address = true

   tags = {
    Name = "Public Instance  ${count.index + 1}"
    Environment = "Development"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = var.ec2_ami_amazon_linux
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_icmp.id
  ]
  key_name = var.ssh_key_name
  tags = {
    Name = "Bastion Host"
  }
}