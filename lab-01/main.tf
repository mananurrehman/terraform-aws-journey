# LAB 01 - Your First EC2 Instance

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my_first_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name        = "lab-01-first-server"
    Environment = "learning"
    Lab         = "01"
    ManagedBy   = "Terraform"
  }
}
