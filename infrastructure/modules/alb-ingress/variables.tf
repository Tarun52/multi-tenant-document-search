variable "env" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "api_service_name" {
  type = string
}

variable "worker_service_name" {
  type = string
}
