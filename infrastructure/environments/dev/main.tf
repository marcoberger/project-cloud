# Terraform configuration
# ========================================
terraform {

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
  source                         = "git::https://github.com/marcoberger/project-cloud-roles-permissions.git"
  s3_bucket_frontend_id          = module.frontend.s3_bucket_frontend_id
  origin_access_identity_iam_arn = module.frontend.origin_access_identity_iam_arn
  environment                    = local.enviroment_identifier
}

