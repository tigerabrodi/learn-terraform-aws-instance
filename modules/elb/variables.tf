variable "elb_name" {
  description = "The name of the ELB"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to attach to the ELB"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group to associate with the ELB"
  type        = string
}

variable "instance_ids" {
  description = "A list of instance IDs to attach to the ELB"
  type        = list(string)
}
