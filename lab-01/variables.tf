# VARIABLES - Lab 01

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
}
