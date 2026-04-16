# OUTPUTS - Lab 01

output "instance_id" {
  description = "The unique ID AWS assigned to your EC2 instance"
  value       = aws_instance.my_first_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_first_server.public_ip
}

output "instance_state" {
  description = "Current state of the EC2 instance (running, stopped, etc.)"
  value       = aws_instance.my_first_server.instance_state
}

output "availability_zone" {
  description = "Which AZ AWS launched the instance in"
  value       = aws_instance.my_first_server.availability_zone
}
