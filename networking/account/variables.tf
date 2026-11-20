terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "availability_zones" {
  description = "List of AWS Availability Zones"
  type        = list(string)
}