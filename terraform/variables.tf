variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "terraform_state_s3_bucket_name" {
  description = "The Name of the S3 bucket for storing Terraform state"
  type        = string
  default     = "tati.terraform-state-s3-bucket"
}

variable "task_bucket_name" {
  description = "The Name of the S3 bucket for Task1"
  type        = string
  default     = "tati.task1-new-bucket"
}

variable "aws_iam_role_name" {
  description = "AWS IAM role name"
  type        = string
  default     = "GithubaActionsRole"
}