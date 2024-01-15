variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}
