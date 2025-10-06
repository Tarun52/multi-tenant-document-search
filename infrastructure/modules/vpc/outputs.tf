output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the created VPC"
}

output "public_subnet_ids" {
  value       = [for subnet in aws_subnet.public : subnet.id]
  description = "List of public subnet IDs"
}

output "eks_private_subnet_ids" {
  value       = [for subnet in aws_subnet.eks_private : subnet.id]
  description = "List of private subnet IDs for EKS"
}

output "services_private_subnet_ids" {
  value       = [for subnet in aws_subnet.services_private : subnet.id]
  description = "List of private subnet IDs for RDS, OpenSearch, ElastiCache"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "ID of the Internet Gateway"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat.*.id
  description = "List of NAT Gateway IDs"
}
