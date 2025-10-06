output "fqdn" {
  description = "Fully qualified domain name"
  value       = "${var.subdomain}.${var.domain_name}"
}

output "zone_id" {
  description = "Hosted Zone ID"
  value       = aws_route53_zone.document_zone.zone_id
}
