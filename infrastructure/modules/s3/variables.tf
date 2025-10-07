variable "bucket_name" {
  description = "Name of the S3 bucket for document storage"
  type        = string
}

variable "tags" {
  description = "Tags to assign to all resources"
  type        = map(string)
  default     = {}
}
