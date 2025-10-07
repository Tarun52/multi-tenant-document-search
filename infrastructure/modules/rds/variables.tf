variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "eks_node_sg_id" {
  description = "Security group ID of EKS nodes for access"
  type        = string
}

variable "engine_version" {
  type    = string
  default = "15.3"
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type        = string
  sensitive   = true
  description = "RDS password (injected into Secrets Manager)"
}

variable "backup_retention" {
  type    = number
  default = 7
}

variable "backup_window" {
  type    = string
  default = "03:00-04:00"
}

variable "parameter_group" {
  type    = string
  default = "default.postgres15"
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
