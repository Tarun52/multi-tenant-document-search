variable "env" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones (e.g., [\"us-east-1a\", \"us-east-1b\", \"us-east-1c\"])"
}

variable "public_subnets" {
  type = map(string)
  description = "Map of AZ to public subnet CIDR (e.g. { \"us-east-1a\" = \"10.0.1.0/24\" })"
}

variable "eks_private_subnets" {
  type = map(string)
  description = "Map of AZ to private subnet CIDR for EKS (e.g. { \"us-east-1a\" = \"10.0.101.0/24\" })"
}

variable "services_private_subnets" {
  type = map(string)
  description = "Map of AZ to private subnet CIDR for RDS, OpenSearch, ElastiCache (e.g. { \"us-east-1a\" = \"10.0.201.0/24\" })"
}
