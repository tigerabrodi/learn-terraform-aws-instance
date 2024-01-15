
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

output "nacl_id" {
  description = "The ID of the NACL"
  value       = aws_network_acl.example_nacl.id
}

output "nacl_name" {
  description = "The name of the NACL"
  value       = aws_network_acl.example_nacl.tags.Name
}
