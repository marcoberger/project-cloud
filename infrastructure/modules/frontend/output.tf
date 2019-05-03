output "origin_access_identity_iam_arn" {
  value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
}

output "s3_bucket_frontend_id" {
  value = "${aws_s3_bucket.s3_bucket_frontend.id}"
}

output "s3_bucket_frontend_arn" {
  value = "${aws_s3_bucket.s3_bucket_frontend.arn}"
}

output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.cloudfront_distribution.domain_name}"
}
