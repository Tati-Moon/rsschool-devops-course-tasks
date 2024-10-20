# The 'aws_internet_gateway' resource creates an Internet Gateway for the VPC.
# An Internet Gateway allows communication between instances in the VPC and the Internet.
# It is a horizontally-scaled, redundant, and highly available VPC component that 
# allows resources in the VPC to access the Internet.
resource "aws_internet_gateway" "my_project_internet_gateway" {
  # The VPC to which this Internet Gateway will be attached.
  vpc_id = aws_vpc.my_project_vpc.id

  tags = {
    Name = "My Project Internet Gateway"
  }
}

# The 'aws_nat_gateway' resource creates a NAT Gateway within a public subnet.
# A NAT Gateway allows instances in a private subnet to initiate outbound traffic 
# to the Internet, while preventing the Internet from initiating connections with 
# those instances. This is crucial for private subnets that need to access 
# updates or external resources without exposing them to incoming traffic.
resource "aws_nat_gateway" "my_project_nat_gateway" {
  # The 'allocation_id' parameter is the ID of the Elastic IP address associated with the NAT Gateway.
  allocation_id = aws_eip.nat_eip.id

  # The 'subnet_id' parameter specifies which public subnet this NAT Gateway is placed in.
  # It is necessary for the NAT Gateway to be in a public subnet so it can access the Internet.
  subnet_id = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.my_project_internet_gateway]

  tags = {
    Name = "My Project NAT Gateway"
  }
}

# The 'aws_eip' resource creates an Elastic IP address, which is a static, public IP address 
# that can be associated with the NAT Gateway. This allows instances in the private subnet 
# to communicate with the Internet using a consistent IP address.
resource "aws_eip" "nat_eip" {
  domain = "vpc" 

  tags = {
    Name = "My Project NAT Elastic IP"
  }
}
