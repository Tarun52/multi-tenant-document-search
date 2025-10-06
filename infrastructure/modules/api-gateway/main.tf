resource "aws_api_gateway_rest_api" "document_api" {
  name = "${var.env}-document-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = var.tags
}

resource "aws_api_gateway_resource" "document_proxy" {
  rest_api_id = aws_api_gateway_rest_api.document_api.id
  parent_id   = aws_api_gateway_rest_api.document_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "document_method" {
  rest_api_id   = aws_api_gateway_rest_api.document_api.id
  resource_id   = aws_api_gateway_resource.document_proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.document_authorizer.id
}

resource "aws_api_gateway_integration" "document_integration" {
  rest_api_id             = aws_api_gateway_rest_api.document_api.id
  resource_id             = aws_api_gateway_resource.document_proxy.id
  http_method             = aws_api_gateway_method.document_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = var.alb_ingress_address
}

resource "aws_api_gateway_authorizer" "document_authorizer" {
  name        = "${var.env}-document-authorizer"
  rest_api_id = aws_api_gateway_rest_api.document_api.id

  identity_source = "method.request.header.Authorization"
  type            = "COGNITO_USER_POOLS"
  provider_arns    = [var.user_pool_arn]
}

resource "aws_api_gateway_deployment" "document_deployment" {
  rest_api_id = aws_api_gateway_rest_api.document_api.id
  stage_name  = var.stage
  depends_on  = [aws_api_gateway_integration.document_integration]
}
