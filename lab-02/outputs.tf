# ============================================================
# OUTPUTS - Lab 02
# ============================================================

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP — use this to SSH in or test the web server"
  value       = aws_instance.web_server.public_ip
}

output "security_group_id" {
  description = "ID of the Security Group attached to this instance"
  value       = aws_security_group.web_sg.id
}

output "ssh_command" {
  description = "Ready-to-use SSH command (update the path to your .pem file)"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.web_server.public_ip}"
}

output "web_url" {
  description = "URL to test the Apache web server installed via user_data"
  value       = "http://${aws_instance.web_server.public_ip}"
}
