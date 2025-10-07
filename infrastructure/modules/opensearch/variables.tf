variable "env" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
}

variable "instance_type" {
  description = "Instance type for OpenSearch nodes"
  type        = string
  default     = "m6g.large.search"
}

variable "instance_count" {
  description = "Number of OpenSearch nodes"
  type        = number
  default     = 3
}

variable "subnet_ids" {
  description = "List of private subnet IDs for OpenSearch VPC deployment"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID to attach to OpenSearch domain (should allow access from EKS nodes)"
  type        = string
}

variable "volume_size" {
  description = "EBS volume size (in GB) per OpenSearch node"
  type        = number
  default     = 50
}

variable "advanced_security_enabled" {
  description = "Enable fine-grained access control"
  type        = bool
  default     = true
}

variable "internal_user_database_enabled" {
  description = "Enable internal user DB for OpenSearch auth"
  type        = bool
  default     = true
}

variable "master_user_name" {
  description = "Master user for OpenSearch domain"
  type        = string
  sensitive   = true
}

variable "master_user_password" {
  description = "Password for the master user"
  type        = string
  sensitive   = true
}

variable "access_policies_json" {
  description = "IAM policy as JSON for access control"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
