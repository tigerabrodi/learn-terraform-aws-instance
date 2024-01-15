output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.example_vpc.id
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = aws_vpc.example_vpc.tags.Name
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.example_subnet.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.app_server_sg.name
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.app_server_sg.id
}

output "nacl_id" {
  description = "The ID of the NACL"
  value       = aws_network_acl.example_nacl.id
}

output "nacl_name" {
  description = "The name of the NACL"
  value       = aws_network_acl.example_nacl.tags.Name
}
