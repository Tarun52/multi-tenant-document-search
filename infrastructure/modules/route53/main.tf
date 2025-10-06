resource "aws_route53_zone" "document_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "api_record" {
  zone_id = aws_route53_zone.document_zone.zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = var.alb_dns
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}
