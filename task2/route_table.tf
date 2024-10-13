resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_project_internet_gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_project_vpc.id

  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_project_nat_gateway.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

# Associate Public NACL with Public Subnets
resource "aws_network_acl_association" "public_subnet_nacl_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  network_acl_id = aws_network_acl.public_nacl.id
}

# Associate Private NACL with Private Subnets
resource "aws_network_acl_association" "private_subnet_nacl_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  network_acl_id = aws_network_acl.private_nacl.id
}
