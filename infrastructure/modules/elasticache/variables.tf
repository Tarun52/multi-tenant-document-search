variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_node_sg_id" {
  description = "Security group ID of EKS nodes (to allow access to Redis)"
  type        = string
}

variable "node_type" {
  type = string
}

variable "node_count" {
  type = number
}

variable "parameter_group_name" {
  type = string
  default = "default.redis6.x"
}

variable "tags" {
  type = map(string)
  default = {}
}
