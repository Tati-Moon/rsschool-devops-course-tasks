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

variable "ec2_ami_amazon_linux" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-0e6a13e7a5b66ff4d"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for the bastion host."
  type        = string
  default     = "my-key-pair"
}

variable "allowed_ip_cidr" {
  description = "CIDR block for allowed IP addresses to access the bastion host."
  type        = string
  default     = "31.182.250.192/32" 
}