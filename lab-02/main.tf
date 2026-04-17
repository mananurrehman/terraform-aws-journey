# LAB 02 - EC2 + Security Group

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

# RESOURCE 1: Security Group
# -----------------------------

resource "aws_security_group" "web_sg" {
  name        = var.sg_name
  description = "Security group for lab-02 EC2 instance - allows SSH and HTTP"

  # ----------------------------------------------------------
  # INGRESS RULES = Inbound traffic (what can reach your server)
  # ----------------------------------------------------------

  # Allow SSH from anywhere (port 22)
  # In production you would restrict this to your own IP.
  # For learning, we allow 0.0.0.0/0 (all IPv4 addresses).
  
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP from anywhere (port 80)
  # This lets anyone access a web server running on this instance.
  
  ingress {
    description = "HTTP web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ----------------------------------------------------------
  # EGRESS RULES = Outbound traffic (what your server can reach)
  # ----------------------------------------------------------

  # Allow all outbound traffic
  # -1 protocol means ALL protocols
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = var.sg_name
    Lab       = "02"
    ManagedBy = "Terraform"
  }
}

# RESOURCE 2: EC2 Instance
# -----------------------------

# Same EC2 as Lab 01 but now we:
#   1. Attach the Security Group above
#   2. Add a key_name for SSH access (you must create this in AWS first)
#   3. Add user_data script that installs a web server on boot
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # Attach the Security Group we defined above.
  # Notice the reference syntax: <resource_type>.<local_name>.<attribute>
  # Terraform sees this reference and knows to create the SG BEFORE the EC2.
  # This is called an IMPLICIT DEPENDENCY.
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Key pair for SSH access.
  # You must create this in AWS Console first:
  # EC2 -> Key Pairs -> Create Key Pair -> download .pem file
  # Then set the name in terraform.tfvars
  key_name = var.key_name

  # user_data runs this script automatically when the instance first boots.
  # We install Apache web server so we can test HTTP access.
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Lab 02 - Terraform EC2 + Security Group</h1><p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "lab-02-web-server"
    Environment = "learning"
    Lab         = "02"
    ManagedBy   = "Terraform"
  }
}
