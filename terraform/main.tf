# AWS Region
provider "aws" {
  region = var.aws_region
}

# Cerate new S3 bucket with name "Task1"
resource "aws_s3_bucket" "task_bucket" {
  bucket = var.task_bucket_name

  tags = {
    Name = "Task1"
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

# Create IAM Role for Github Actions
resource "aws_iam_role" "github_actions_role" {
  name               = var.aws_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json

  tags = {
    Name = var.aws_iam_role_name
  }
}

# Create IAM Policy Document for GitHub Actions OIDC
data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner_1}/rsschool-devops-course-tasks:*", "repo:${var.github_owner_2}/rsschool-devops-course-tasks:*"]
    }
  }
}

# Attach required policies to the IAM role
resource "aws_iam_role_policy_attachment" "github_actions_ec2_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_route53_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_s3_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_iam_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_vpc_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_sqs_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}
