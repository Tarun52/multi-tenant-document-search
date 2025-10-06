resource "aws_route53_zone" "document_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "api_gateway_record" {
  zone_id = aws_route53_zone.document_zone.zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = var.api_gw_domain_target
    zone_id                = var.api_gw_zone_id
    evaluate_target_health = false
  }
