variable "env" {
  type = string
}

variable "visibility_timeout_seconds" {
  type    = number
  default = 30
}

variable "message_retention_seconds" {
  type    = number
  default = 345600  # 4 days
}

variable "delay_seconds" {
  type    = number
  default = 0
}

variable "tags" {
  type    = map(string)
  default = {}
}
