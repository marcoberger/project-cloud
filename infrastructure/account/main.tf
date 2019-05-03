# Terraform configuration
# ========================================
locals {
  tags = {
    Environment = "${var.environment}"
    Team        = "${var.team}"
    Project     = "${var.project}"
  }
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "project-cloud"
}

# Resources to manage
# ========================================
resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.environment}-${var.team}-${var.project}-tf-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = "${local.tags}"
}

resource "aws_dynamodb_table" "tf_state_lock" {
  name           = "${var.environment}-${var.team}-${var.project}-tf-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${local.tags}"
}
