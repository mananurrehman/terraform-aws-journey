# ============================================================
# VARIABLES - Lab 02
# ============================================================
# Notice: We do NOT set defaults for sensitive/environment-specific
# values like key_name. Those go in terraform.tfvars instead.
# ============================================================

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
  description = "AMI ID for Amazon Linux 2023 in us-east-1."
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "sg_name" {
  description = "Name for the Security Group resource"
  type        = string
  default     = "lab-02-web-sg"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair for SSH access. Must already exist in your AWS account."
  type        = string
  # No default — this must be set in terraform.tfvars
  # If you don't have a key pair, create one in AWS Console:
  # EC2 -> Key Pairs -> Create key pair
}
