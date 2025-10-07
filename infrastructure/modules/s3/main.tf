resource "aws_s3_bucket" "documents_bucket" {
  bucket = var.bucket_name

  acl    = "private"

  tags = var.tags

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    abort_incomplete_multipart_upload_days = 7

    expiration {
      days = 3650  
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.documents_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
