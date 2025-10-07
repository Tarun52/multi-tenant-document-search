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
  description = "Root domain name"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for services"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for custom domain"
  type        = string
}

variable "custom_domain_name" {
  description = "Custom domain name for API Gateway"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for kubectl"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key name for EC2 instances"
  type        = string
}

variable "nodegroups" {
  description = "Nodegroups configuration map"
  type = map(object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_types   = list(string)
  }))
}

variable "opensearch_password" {
  description = "Password for OpenSearch master user"
  type        = string
  sensitive   = true
}

variable "opensearch_access_policies_json" {
  description = "JSON string of OpenSearch access policies"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
