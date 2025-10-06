resource "aws_cognito_user_pool" "document_user_pool" {
  name = "${var.env}-document-user-pool"

  schema {
    name     = "email"
    required = true
    mutable  = false
  }

  auto_verified_attributes = ["email"]
  alias_attributes         = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  tags = var.tags
}

resource "aws_cognito_user_pool_client" "document_user_pool_client" {
  name         = "${var.env}-document-user-pool-client"
  user_pool_id = aws_cognito_user_pool.document_user_pool.id

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  generate_secret = false

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  allowed_oauth_flows_user_pool_client = false
  supported_identity_providers        = ["COGNITO"]
  allowed_oauth_flows                 = []
  allowed_oauth_scopes                = []
}
