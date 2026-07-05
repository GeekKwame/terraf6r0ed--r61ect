variable "aws_region" {
  description = "AWS region to deploy the S3 bucket into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Used to name and tag every resource"
  type        = string
  default     = "terraformed"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for the site's origin. Change this, S3 bucket names are global."
  type        = string
  default     = "terraformed-site-eddie-12345"
}


variable "domain_name" {
  description = "Custom domain for the site (e.g. terraformed.dev). Leave blank to skip Route 53 + ACM and just use the CloudFront domain."
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for domain_name. Required only if domain_name is set."
  type        = string
  default     = ""

  validation {
    condition     = var.domain_name == "" || var.hosted_zone_id != ""
    error_message = "hosted_zone_id is required when domain_name is set."
  }
}

variable "site_source_dir" {
  description = "Local path to the static site files to upload"
  type        = string
  default     = "../site"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "practice"
}
