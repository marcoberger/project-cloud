# Terraform configuration
# ========================================
terraform {
  required_version = ">=0.11.13"

  backend "s3" {
    bucket         = "dev-jedis-project-cloud-tf-state"
    key            = "dev/jedis/project-cloud/application/state.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "dev-jedis-project-cloud-tf-state-lock"
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "project-cloud"
}

locals {
  enviroment_identifier = "dev"
}

# Call single modules
# ========================================

module "backend" {
  source      = "../../modules/backend"
  environment = local.enviroment_identifier
}

module "frontend" {
  source         = "../../modules/frontend"
  eb_lb_dns_name = module.backend.eb_lb_dns_name
  environment    = local.enviroment_identifier
}

module "roles-and-permissions" {
  source                         = "../../modules/roles-and-permissions"
  s3_bucket_frontend_id          = module.frontend.s3_bucket_frontend_id
  s3_bucket_frontend_arn         = module.frontend.s3_bucket_frontend_arn
  origin_access_identity_iam_arn = module.frontend.origin_access_identity_iam_arn
  environment                    = local.enviroment_identifier
}

