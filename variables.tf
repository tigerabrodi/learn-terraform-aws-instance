
variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "ExampleVPC"

}
