# AWS Region
provider "aws" {
  region = var.aws_region
}

# Cerate new S3 bucket with name "Task2"
resource "aws_s3_bucket" "task_bucket" {
  bucket = var.task_bucket_name

  tags = {
    Name = "Task2"
  }
}

# Add version for S3
resource "aws_s3_bucket_versioning" "task_bucket_versioning" {
  bucket = aws_s3_bucket.task_bucket.id
  versioning_configuration {
    status = "Enabled"
  }

  # Ensure versioning only runs after the bucket is created
  depends_on = [aws_s3_bucket.task_bucket]
}

# Add encryption for s3
resource "aws_s3_bucket_server_side_encryption_configuration" "task_bucket_sse" {
  bucket = aws_s3_bucket.task_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  # Ensure encryption is configured after bucket creation
  depends_on = [aws_s3_bucket.task_bucket]
}