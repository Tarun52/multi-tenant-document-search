resource "aws_dynamodb_table" "document_metadata" {
  name         = "${var.env}-document-metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "document_id"

  attribute {
    name = "document_id"
    type = "S"
  }

  tags = var.tags
}
