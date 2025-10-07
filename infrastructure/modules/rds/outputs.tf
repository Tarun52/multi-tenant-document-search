output "rds_endpoint" {
  description = "Host address of the PostgreSQL instance"
  value       = aws_db_instance.postgres.address
}

output "rds_reader_endpoint" {
  description = "Read replica / reader endpoint (if applicable)"
  value       = aws_db_instance.postgres.reader_endpoint
}

output "rds_port" {
  description = "Port of PostgreSQL"
  value       = aws_db_instance.postgres.port
}

output "rds_sg_id" {
  description = "Security Group ID of RDS"
  value       = aws_security_group.rds_sg.id
}

output "rds_password_secret_arn" {
  description = "ARN of the stored password in Secrets Manager"
  value       = aws_secretsmanager_secret.rds_password.arn
}
