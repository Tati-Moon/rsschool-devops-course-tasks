output "aws_region" {
  value       = var.aws_region
  description = "The AWS region"
}

output "new_bucket_name" {
  value       = aws_s3_bucket.task_bucket.bucket
  description = "The name of the newly created S3 bucket"
}

output "terraform_state_bucket_name" {
  value       = var.terraform_state_s3_bucket_name
  description = "The name of the S3 bucket used for Terraform state"
}

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

output "bastion_host_id" {
  value = aws_instance.bastion_host.id
}
