
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}


output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.app_server_sg.name
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.app_server_sg.id
}
