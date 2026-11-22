variable "instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "private_subnet_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "public_subnet_secondary_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "profile_vpc_cidr" {
  type = string
}

