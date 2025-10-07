resource "aws_opensearch_domain" "document_search" {
  domain_name = "${var.env}-document-search"

  cluster_config {
    instance_type        = var.instance_type
    instance_count       = var.instance_count
    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = length(var.subnet_ids)
    }
  }

  vpc_options {
    subnet_ids = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  advanced_security_options {
    enabled = var.advanced_security_enabled
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  tags = var.tags
}

resource "aws_opensearch_domain_policy" "document_search_policy" {
  domain_name = aws_opensearch_domain.document_search.domain_name
  access_policies = var.access_policies_json
}

