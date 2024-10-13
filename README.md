# rsschool-devops-course-tasks

Task 1: AWS Account Configuration
https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/1_basic-configuration/task_1.md

This repository contains Terraform configurations for automating AWS infrastructure using GitHub Actions.

## Prerequisites

- **AWS CLI v2**
- **Terraform v1.6+**
- **AWS Account with sufficient IAM permissions**
- **GitHub repository with secrets configured for AWS_REGION, AWS_ROLE_TO_ASSUME, and TERRAFORM_VERSION**

## Setup

### Steps

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Tati-Moon/rsschool-devops-course-tasks.git
   cd rsschool-devops-course-tasks
   ```

### 2. Configure AWS CLI
Ensure that your AWS CLI is properly configured with the necessary credentials. You will need the `Access Key ID` and `Secret Access Key` for the IAM user with sufficient permissions.

Run the following command to configure AWS CLI:

```bash
aws configure
```

Follow the prompts to enter:
- `AWS Access Key ID`: Your IAM user's access key.
- `AWS Secret Access Key`: Your IAM user's secret key.
- `Default region name`: Enter the AWS region where you want to deploy your infrastructure (e.g., `eu-central-1`).
- `Default output format`: You can specify `json`, or leave this blank for default formatting.

Once configured, verify that AWS CLI is working correctly by running:

```bash
aws sts get-caller-identity
```

### 3. Setup GitHub Secrets
To securely pass sensitive information to GitHub Actions, you need to configure repository secrets in your GitHub project.

Go to your repository on GitHub:
1. Navigate to **Settings** > **Secrets and variables** > **Actions**.
2. Click **New repository secret** and add the following secrets:
   - `AWS_REGION`: The AWS region where your infrastructure is deployed (e.g., `eu-central-1`).
   - `AWS_ROLE_TO_ASSUME`: The IAM role to assume for GitHub Actions (e.g., `arn:aws:iam::000000000000:role/GithubActionsRole`).
   - `TERRAFORM_VERSION`: The Terraform version you want to use (e.g., `1.6.0`).

### 4. Run GitHub Actions Workflow
Once you've set up AWS CLI and GitHub secrets, you can trigger the GitHub Actions workflow.

- **Push to the `main` branch** or **create a pull request** to trigger the automated workflow, which will run Terraform commands to deploy your infrastructure on AWS.

You can view the workflow progress in the **Actions** tab of your GitHub repository.

### 5. Monitor Terraform Output
During the GitHub Actions run, Terraform will:
- **Initialize** the configuration and backend (S3 bucket for storing state).
- **Plan** the changes to the infrastructure.
- **Apply** those changes automatically to create or update AWS resources.

### 6. Check the AWS Console
Once the workflow completes successfully, you can visit the AWS Management Console to verify the deployed resources, such as the S3 bucket and IAM roles.

## Inputs

- `aws_region`: The AWS region where resources will be deployed (default: `eu-central-1`).
- `task_bucket_name`: The name of the S3 bucket to be created (default: `tati.task1-new-bucket`).

## Outputs

- `new_bucket_name`: The name of the newly created S3 bucket.
- `github_actions_role_arn`: The ARN of the IAM role created for GitHub Actions.

## Troubleshooting

### Common Errors

1. **Access Denied (403)**:
   - Check that the IAM role and user have the correct permissions.
   - Verify that OIDC provider is correctly configured in AWS to trust GitHub Actions.
   
2. **Terraform Backend Issues**:
   - Ensure the S3 bucket for Terraform state exists and is properly configured.
   - Make sure the bucket has encryption enabled and the correct permissions.

### Design Choices

- **Remote State**: S3 is used for storing Terraform state to ensure that infrastructure changes are tracked and consistent across multiple users or automated workflows.
- **IAM Role with OIDC**: This design eliminates the need for long-lived AWS credentials by allowing GitHub Actions to assume an AWS role via OpenID Connect (OIDC), providing a more secure and modern authentication approach.

## Project steps:

### 1. Installed AWS CLI and Terraform
- Followed the instructions to install **AWS CLI 2**.
- Followed the instructions to install **Terraform 1.6+**.
- **Optional:** Configured Terraform version manager **tfenv**.

![LOCAL SETTINGS](img/task1/02_check_settings.png)

### 2. Created IAM User and Configured MFA
- Navigated to IAM in the AWS account and created a new user with the following policies attached:
  - **AmazonEC2FullAccess**
  - **AmazonRoute53FullAccess**
  - **AmazonS3FullAccess**
  - **IAMFullAccess**
  - **AmazonVPCFullAccess**
  - **AmazonSQSFullAccess**
  - **AmazonEventBridgeFullAccess**
- Configured MFA for both the new user and the root user.
- Generated a new pair of **Access Key ID** and **Secret Access Key** for the user.

![IAM SETTINGS](img/task1/01_IAM_user_settings.png)

### 3. Configured AWS CLI
- Configured AWS CLI to use the new user's credentials.
- Verified the configuration by running the command: 
  ```bash
  aws ec2 describe-instance-types --instance-types t4g.nano
  ```
### 4. Created a GitHub Repository for Terraform Code
- Utilized a personal GitHub account to create a repository named **rsschool-devops-course-tasks**. This repository served as the central location for storing and managing the Terraform configuration files.

### 5. Created a Bucket for Terraform States
- Established a dedicated S3 bucket to manage Terraform state files, adhering to best practices for state management. The S3 bucket was configured as the backend for storing the Terraform state, ensuring secure and efficient tracking of infrastructure changes.

### 6. Created an IAM Role for GitHub Actions
- Created an IAM role named **GithubActionsRole**, assigning it the same permissions as the previously created IAM user in step 2. The attached policies included:
  - **AmazonEC2FullAccess**
  - **AmazonRoute53FullAccess**
  - **AmazonS3FullAccess**
  - **IAMFullAccess**
  - **AmazonVPCFullAccess**
  - **AmazonSQSFullAccess**
  - **AmazonEventBridgeFullAccess**
  
  This role enabled GitHub Actions to perform operations on AWS resources securely.

  ![ROLE SETTINGS](img/task1/03_IAM_role_settings.png)

### 7. Configured an Identity Provider and Trust Policies for GitHub Actions
- Updated the **GithubActionsRole** IAM role to include a Trust policy that allows GitHub Actions to assume the role. This configuration was based on guidance from:
  - [IAM Roles Terms and Concepts](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms.html)
  - [GitHub Tutorial](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-your-deployments)
  - [AWS Documentation on OIDC Providers](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html)
  
  (*Note: Replace **GitHubOrg** with the appropriate GitHub username in this context.*)

  ![S3 BUCKETS](img/task1/04_s3_buckets.png)

### 8. Created a GitHub Actions Workflow for Deployment via Terraform
- Developed a GitHub Actions workflow to automate the deployment process using Terraform. The workflow comprised three jobs that were triggered on pull requests and pushes to the default branch:
  - **terraform-check**: This job was responsible for format checking the Terraform code using `terraform fmt`.
  - **terraform-plan**: This job executed the `terraform plan` command to outline the changes that would be made to the infrastructure.
  - **terraform-apply**: This job deployed the Terraform configurations using `terraform apply`, applying the changes to the AWS infrastructure.
  
  This workflow streamlined the infrastructure deployment process and ensured consistent application of Terraform configurations.

  ![TERRAFORM](img/task1/05_actions_result.png)