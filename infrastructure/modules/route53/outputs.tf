output "fqdn" {
  value = "${var.subdomain}.${aws_route53_zone.document_zone.name}"
}
