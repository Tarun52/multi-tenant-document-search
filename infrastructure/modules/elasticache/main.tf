resource "aws_security_group" "redis_sg" {
  name        = "${var.env}-redis-sg"
  description = "Security group for ElastiCache Redis"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow access from EKS nodes"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.env}-redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "${var.env}-redis"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = var.node_count
  parameter_group_name = var.parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]
  tags                 = var.tags
}
