variable "account_region" {
  description = "AWS region to create the account network in"
  type        = string
  default     = "ap-southeast-1"
}

variable "profile_region" {
  description = "AWS region to create the account network in"
  type        = string
  default     = "ap-southeast-2"
}

variable "statement_region" {
  description = "AWS region to create the account network in"
  type        = string
  default     = "ap-southeast-3"
}

variable "account_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "account-admin"
}

variable "profile_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "profile-admin"
}

variable "statement_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "statement-admin"
}