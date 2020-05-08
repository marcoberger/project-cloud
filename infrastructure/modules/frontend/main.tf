locals {
  tags = {
    Environment = var.environment
    Team        = var.team
    Project     = var.project
  }

  ressource_prefix = "${var.environment}-${var.team}-${var.project}"

  frontend_build_folder_path = "../../../frontend/build"
  default_index_document     = "index.html"

  prod_max_ttl                  = 31536000
  dev_max_ttl                   = 0
  prod_default_ttl              = 86400
  dev_default_ttl               = 0
  cloudfront_frontend_origin_id = "${local.ressource_prefix}-frontend-origin"
  cloudfront_backend_origin_id  = "${local.ressource_prefix}-backend-origin"
}

# Resources to manage - S3 for frontend deployment and CloudFront
# ========================================================================

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "s3_bucket_frontend" {
  bucket = "${local.ressource_prefix}-frontend-${random_string.bucket_suffix.result}"

  website {
    index_document = local.default_index_document
  }

  tags = local.tags
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "The origin access identity required by CloudFront to access the S3 bucket"
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket_frontend.bucket_domain_name
    origin_id   = local.cloudfront_frontend_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.eb_lb_dns_name
    origin_id   = local.cloudfront_backend_origin_id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  comment             = "The ${var.project} frontend"
  default_root_object = local.default_index_document

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = local.cloudfront_frontend_origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = var.environment == "dev" ? local.dev_default_ttl : local.prod_default_ttl
    max_ttl                = var.environment == "dev" ? local.dev_max_ttl : local.prod_max_ttl
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  ordered_cache_behavior {
    path_pattern     = "static/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront_frontend_origin_id

    forwarded_values {
      query_string = true
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = var.environment == "dev" ? local.dev_default_ttl : local.prod_default_ttl
    max_ttl                = var.environment == "dev" ? local.dev_max_ttl : local.prod_max_ttl
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "greeting"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront_backend_origin_id

    forwarded_values {
      query_string = true
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = var.environment == "dev" ? local.dev_default_ttl : local.prod_default_ttl
    max_ttl                = var.environment == "dev" ? local.dev_max_ttl : local.prod_max_ttl
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "starwars-character"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront_backend_origin_id

    forwarded_values {
      query_string = true
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = var.environment == "dev" ? local.dev_default_ttl : local.prod_default_ttl
    max_ttl                = var.environment == "dev" ? local.dev_max_ttl : local.prod_max_ttl
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 300
    response_code         = 404
    response_page_path    = "/${local.default_index_document}"
  }

  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 300
    response_code         = 403
    response_page_path    = "/${local.default_index_document}"
  }

  tags = local.tags
}

# Deployment of static resources for frontend
# ========================================================================

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${local.frontend_build_folder_path} s3://${aws_s3_bucket.s3_bucket_frontend.id}"
  }

  triggers = {
    deployment_timestamp = timestamp()
  }
}

