variable "env" {
  description = "Environment name"
  type        = string
}

variable "api_gateway_id" {
  description = "API Gateway REST API ID to associate with WAF"
  type        = string
}

variable "rules" {
  description = "List of WAFv2 rules"
  type        = list(object({
    name     = string
    priority = number
    action   = string # "ALLOW", "BLOCK", "COUNT"
    statement = any
    visibility_config = object({
      sampled_requests_enabled = bool
      cloudwatch_metrics_enabled = bool
      metric_name = string
    })
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
