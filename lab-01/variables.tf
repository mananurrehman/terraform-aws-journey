# VARIABLES - Lab 01
# =====================
# Variables make Terraform code reusable and configurable.
# You define them here and use them in main.tf with var.<name>
# =====================

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type. t2.micro is Free Tier eligible."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for Amazon Linux 2023 in us-east-1. Update this if you change region."
  type        = string
  default     = "ami-0c02fb55956c7d316"

  # To find latest AMIs:
  # AWS Console -> EC2 -> Launch Instance -> search "Amazon Linux 2023"
  # Or use AWS CLI: aws ec2 describe-images --owners amazon --filters "Name=name,Values=al2023-ami-*" --query "Images[*].[ImageId,Name]" --output table
}
