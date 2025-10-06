variable "env" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS will be deployed"
}

variable "eks_private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EKS nodes"
}

variable "nodegroups" {
  type = map(object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_types   = list(string)
  }))
  description = "Map of nodegroups with autoscaling configs and instance types"
}

variable "namespace_names" {
  type        = list(string)
  description = "List of Kubernetes namespaces to create (e.g., [\"system\", \"monitoring\", \"application\"])"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
