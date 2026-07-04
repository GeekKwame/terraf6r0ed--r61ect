output "bucket_name" {
  description = "Name of the S3 origin bucket"
  value       = aws_s3_bucket.site.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (useful for cache invalidations in CI)"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_domain_name" {
  description = "Default CloudFront domain — works immediately, no DNS needed"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "website_url" {
  description = "The URL your site is actually reachable at"
  value       = local.use_custom_domain ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.cdn.domain_name}"
}
