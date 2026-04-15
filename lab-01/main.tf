# LAB 01 - Your First EC2 Instance
# =======================================
# This is the most basic Terraform configuration possible.
# We configure one provider (AWS) and define one resource (EC2).
# =======================================

# The terraform block defines settings for Terraform itself.
# required_providers tells Terraform which plugin to download.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# The provider block tells Terraform WHERE to create resources.

# Region is pulled from variables.tf so it is easy to change.

provider "aws" {
  region = var.aws_region
}

# The resource block is what actually creates infrastructure.

# Syntax: resource "<provider_type>" "<local_name>" { }

resource "aws_instance" "my_first_server" {
  # IMPORTANT: AMI IDs are region-specific. Update if you change region.
  ami = var.ami_id

  # t2.micro = 1 vCPU, 1GB RAM — Free Tier eligible
  instance_type = var.instance_type

  # Tags = key-value metadata attached to AWS resources.
  # Best practice: always tag resources for cost tracking and clarity.
  
  tags = {
    Name        = "lab-01-first-server"
    Environment = "learning"
    Lab         = "01"
    ManagedBy   = "Terraform"
  }
}
