resource "aws_sqs_queue" "document_jobs" {
  name                       = "${var.env}-document-jobs-queue"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  delay_seconds              = var.delay_seconds
  tags                       = var.tags
}
