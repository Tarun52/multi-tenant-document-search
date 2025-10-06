variable "domain_name" {
  description = "Root domain name, e.g. example.com"
  type        = string
}

variable "subdomain" {
  description = "Subdomain to create, e.g. api"
  type        = string
}

variable "api_gw_domain_target" {
  description = "API Gateway domain target for Route53 alias"
  type        = string
}

variable "api_gw_zone_id" {
  description = "API Gateway's hosted zone ID for alias record"
  type        = string
}

