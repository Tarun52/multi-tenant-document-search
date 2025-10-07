output "opensearch_domain_name" {
  description = "OpenSearch domain name"
  value       = aws_opensearch_domain.document_search.domain_name
}

output "opensearch_endpoint" {
  description = "OpenSearch HTTPS endpoint"
  value       = aws_opensearch_domain.document_search.endpoint
}

output "opensearch_security_group_id" {
  description = "Security Group ID used for OpenSearch"
  value       = var.security_group_id
}

output "opensearch_arn" {
  description = "ARN of the OpenSearch domain"
  value       = aws_opensearch_domain.document_search.arn
}
