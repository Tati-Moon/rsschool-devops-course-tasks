output "vpc_id" {
  value = aws_vpc.my_project_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.my_project_nat_gateway.id
}

/*
output "bastion_host_id" {
  value = aws_instance.bastion_host.id
}
*/