provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  env    = var.env
  tags   = var.tags
}

module "eks" {
  source = "./modules/eks"
  env                     = var.env
  vpc_id                  = module.vpc.vpc_id
  eks_private_subnet_ids  = module.vpc.eks_private_subnet_ids
  public_subnet_ids       = module.vpc.public_subnet_ids
  tags                    = var.tags
}

module "alb" {
  source            = "./modules/alb"
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  depends_on        = [module.eks]
}

module "alb_ingress" {
  source              = "./modules/alb-ingress"
  env                 = var.env
  public_subnet_ids   = module.vpc.public_subnet_ids
  api_service_name    = "document-api-service"
  worker_service_name = "document-worker"
  depends_on          = [module.alb]
}

module "api-gateway" {
  source                   = "./modules/api-gateway"
  env                      = var.env
  stage                    = "prod"
  backend_integration_uri  = module.alb_ingress.ingress_address
  custom_domain_name       = var.custom_domain_name
  certificate_arn          = var.certificate_arn
  user_pool_arn            = module.cognito.user_pool_arn
  tags                     = var.tags
  depends_on               = [module.alb_ingress]
}

module "route53" {
  source               = "./modules/route53"
  domain_name          = var.domain_name
  subdomain            = var.subdomain
  api_gw_domain_target = module.api-gateway.custom_domain_name
  api_gw_zone_id       = module.api-gateway.custom_domain_zone_id
  depends_on           = [module.api-gateway]
}

module "cognito" {
  source = "./modules/cognito"
  env    = var.env
  tags   = var.tags
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "${var.env}-documents-bucket"
  tags        = var.tags
}

module "dynamodb" {
  source = "./modules/dynamodb"
  env    = var.env
  tags   = var.tags
}

module "sqs" {
  source = "./modules/sqs"
  env    = var.env
  tags   = var.tags
}

module "opensearch" {
  source                     = "./modules/opensearch"
  env                        = var.env
  subnet_ids                 = module.vpc.services_private_subnet_ids
  security_group_id          = module.eks.cluster_security_group_id
  instance_type              = "m6g.large.search"
  instance_count             = 3
  volume_size                = 50
  advanced_security_enabled  = true
  internal_user_database_enabled = true
  master_user_name           = var.env == "prod" ? "admin" : "test"
  master_user_password       = var.opensearch_password
  access_policies_json       = var.opensearch_access_policies_json
  tags                       = var.tags
}

module "elasticache" {
  source           = "./modules/elasticache"
  env              = var.env
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.services_private_subnet_ids
  eks_node_sg_id   = module.eks.worker_security_group_id
  node_type        = "cache.t3.micro"
  node_count       = 1
  tags             = var.tags
}

module "rds" {
  source            = "./modules/rds"
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.services_private_subnet_ids
  eks_node_sg_id    = module.eks.worker_security_group_id
  db_name           = "documents"
  username          = var.db_username
  password          = var.db_password
  tags              = var.tags
}

module "waf" {
  source = "./modules/waf"
  env    = var.env
  tags   = var.tags
}
:wq
