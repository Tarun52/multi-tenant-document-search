variable "env" {
  type = string
}

variable "stage" {
  type = string
}

variable "alb_ingress_address" {
  description = "The ALB ingress address / endpoint to which API Gateway proxies"
  type        = string
}

variable "user_pool_arn" {
  description = "ARN of the Cognito user pool for authorizer"
  type        = string
}

variable "tags" {
  type = map(string)
}
