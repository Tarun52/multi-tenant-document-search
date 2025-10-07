variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace where the service account resides"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account name"
  type        = string
}

variable "env" {
  description = "Environment (dev/stage/prod)"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN of the EKS cluster"
  type        = string
}

variable "policy_json" {
  description = "IAM policy in JSON for the service account"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
