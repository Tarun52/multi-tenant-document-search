output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.document_alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.document_alb.dns_name
}

output "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "document_target_group_arn" {
  description = "Target Group ARN for document service"
  value       = aws_lb_target_group.document_tg.arn
}
