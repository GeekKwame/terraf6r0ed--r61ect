terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Uncomment once you've created a bucket + DynamoDB table for remote state.
  # backend "s3" {
  #   bucket         = "terraformed-tfstate"
  #   key            = "site/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraformed-tf-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

# CloudFront requires ACM certs to live in us-east-1, regardless of where
# everything else is deployed.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
