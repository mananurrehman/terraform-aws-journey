# OUTPUTS - Lab 01
# ==================
# Outputs display useful values after "terraform apply".
# Think of them like return values from your infrastructure.
# ==================

output "instance_id" {
  description = "The unique ID AWS assigned to your EC2 instance"
  value       = aws_instance.my_first_server.id
  # Example value: i-0a1b2c3d4e5f67890
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_first_server.public_ip
  # Note: This will be empty if the instance is in a subnet with no public IP assignment
}

output "instance_state" {
  description = "Current state of the EC2 instance (running, stopped, etc.)"
  value       = aws_instance.my_first_server.instance_state
}

output "availability_zone" {
  description = "Which AZ AWS launched the instance in"
  value       = aws_instance.my_first_server.availability_zone
}
