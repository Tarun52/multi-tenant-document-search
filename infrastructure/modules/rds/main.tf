resource "aws_secretsmanager_secret" "rds_password" {
  name        = "${var.env}/rds/postgres/password"
  description = "RDS PostgreSQL password for ${var.env} environment"
}

resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = var.password
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Postgres access from EKS"
    from_port       = 5432
    to_port         = 5432
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

resource "aws_db_subnet_group" "rds_subnets" {
  name       = "${var.env}-rds-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "postgres" {
  identifier              = "${var.env}-postgres"
  engine                  = "postgres"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type

  name                    = var.db_name
  username                = var.username
  password                = aws_secretsmanager_secret_version.rds_password_version.secret_string
  port                    = 5432

  multi_az                = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnets.name

  backup_retention_period = var.backup_retention
  backup_window           = var.backup_window

  parameter_group_name    = var.parameter_group
  skip_final_snapshot     = var.skip_final_snapshot

  tags = var.tags
}
