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

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default     = "851725229611"
}

variable "github_owner_1" {
  description = "GitHub owner for the first repository"
  type        = string
  default     = "Tati-Moon"
}

variable "github_owner_2" {
  description = "GitHub owner for the second repository"
  type        = string
  default     = "lionna"
}