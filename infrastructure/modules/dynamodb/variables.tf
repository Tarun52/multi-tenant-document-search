variable "env" {
  type        = string
  description = "Environment (dev, prod, etc.)"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
