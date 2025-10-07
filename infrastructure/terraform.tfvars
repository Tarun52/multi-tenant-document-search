env              = "prod"
region           = "us-east-1"
backend_bucket   = "my-terraform-state-bucket"
domain_name      = "example.com"
subdomain        = "api"
custom_domain_name = "api.example.com"
certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/abcd-efgh-ijkl"
db_username       = "admin"
db_password       = "SuperSecretPassword!"
opensearch_access_policies_json = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "*"
    }
  ]
}
POLICY
tags = {
  Project = "DocumentSearch"
  Owner   = "TeamX"
}
