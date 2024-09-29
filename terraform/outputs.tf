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

output "github_actions_role_name" {
  value       = aws_iam_role.github_actions_role.name
  description = "The name of the IAM role created for Github Actions"
}

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "The ARN of the IAM role created for Github Actions"
}