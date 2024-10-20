resource "aws_vpc" "my_project_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "My Project VPC"
    Environment = "Development"
  }
} 
