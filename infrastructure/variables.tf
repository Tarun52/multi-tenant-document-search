variable "env" {
  description = "Environment (dev, prod, etc.)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "backend_bucket" {
  description = "S3 bucket for Terraform state backend"
  type        = string
}

variable "tags" {
  description = "Common tags for AWS resources"
  type        = map(string)
  default     = {}
}

variable "domain_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "custom_domain_name" {
  type = string
}
