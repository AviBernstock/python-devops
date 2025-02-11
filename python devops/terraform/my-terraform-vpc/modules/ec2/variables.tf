variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the instance will be deployed"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the EC2 instance"
  type        = bool
}
