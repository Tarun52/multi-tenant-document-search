resource "aws_wafv2_web_acl" "document_waf" {
  name        = "${var.env}-document-waf"
  description = "WAF for document API Gateway"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action = rule.value.action == "BLOCK" ? { block = {} } :
               rule.value.action == "COUNT" ? { count = {} } : { allow = {} }

      statement = rule.value.statement

      visibility_config {
        sampled_requests_enabled    = rule.value.visibility_config.sampled_requests_enabled
        cloudwatch_metrics_enabled  = rule.value.visibility_config.cloudwatch_metrics_enabled
        metric_name                 = rule.value.visibility_config.metric_name
      }
    }
  }

  visibility_config {
    sampled_requests_enabled    = true
    cloudwatch_metrics_enabled  = true
    metric_name                 = "${var.env}-waf"
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "document_api_assoc" {
  resource_arn = "arn:aws:apigateway:${data.aws_region.current.name}::/restapis/${var.api_gateway_id}/stages/${var.stage}"
  web_acl_arn  = aws_wafv2_web_acl.document_waf.arn
}
