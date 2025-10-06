variable "env" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
}

variable "region" {
  type        = string
  description = "AWS region where EKS will be deployed"
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
  description = "List of private subnet IDs for EKS nodes (ideally 3 from different AZs)"
}

variable "nodegroups" {
  type = map(object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_types   = list(string)
  }))
  description = "Map of EKS managed node groups and their scaling configurations"
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

variable "ssh_key_name" {
  type        = string
  description = "Name of the EC2 SSH key pair to allow SSH access to EKS nodes"
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to the kubeconfig file for interacting with the Kubernetes cluster"
}

# IRSA (IAM Roles for Service Accounts)
variable "irsa_namespace" {
  type        = string
  description = "Kubernetes namespace where the IRSA-enabled service account will be created"
}

variable "irsa_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account to bind to the IAM role"
}

variable "irsa_policy_arn" {
  type        = string
  description = "ARN of the IAM policy to attach to the IRSA role (e.g., S3, Route53 access)"
}
