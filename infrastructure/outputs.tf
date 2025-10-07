output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "api_gateway_invoke_url" {
  value = module.gateway.invoke_url
}

output "custom_domain" {
  value = module.gateway.custom_domain_name
}

output "route53_fqdn" {
  value = module.route53.fqdn
}

output "s3_bucket" {
  value = module.s3.bucket_name
}

output "dynamodb_table" {
  value = module.dynamodb.table_name
}

output "sqs_queue_url" {
  value = module.sqs.queue_url
}

output "opensearch_endpoint" {
  value = module.opensearch.opensearch_endpoint
}

output "redis_endpoint" {
  value = module.elasticache.redis_endpoint
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
