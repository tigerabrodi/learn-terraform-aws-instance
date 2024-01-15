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
