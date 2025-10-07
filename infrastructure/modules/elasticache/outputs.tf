output "redis_endpoint" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes[0].address
}

output "redis_port" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes[0].port
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}
