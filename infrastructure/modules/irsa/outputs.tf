output "iam_role_arn" {
  description = "IAM Role ARN to attach to Kubernetes service account"
  value       = aws_iam_role.irsa_role.arn
}
