output "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}
