# TERRAFORMED 🛠️

A Terraform + AWS practice project with a twist: **the site is the demo**. This
repo provisions the exact infrastructure that serves the landing page inside
`site/`, and a GitHub Actions workflow re-applies it on every push to `main`.

```
visitor → Route 53 (optional) → CloudFront (CDN + TLS) → S3 (private origin)
```

## What gets created

| Resource | Purpose |
|---|---|
| `aws_s3_bucket.site` | Private origin bucket, no public access |
| `aws_cloudfront_distribution.cdn` | CDN + HTTPS in front of the bucket |
| `aws_cloudfront_origin_access_control` | Lets only CloudFront read the bucket |
| `aws_acm_certificate` *(optional)* | TLS cert for a custom domain |
| `aws_route53_record` *(optional)* | DNS alias pointing your domain at CloudFront |

## Run it yourself

```bash
cd terraform
terraform init
terraform plan   -var="bucket_name=your-unique-bucket-name"
terraform apply  -var="bucket_name=your-unique-bucket-name"
```

No custom domain? Skip straight to the CloudFront URL:

```bash
terraform output website_url
```

Want it on your own domain? Add these (your hosted zone must already exist
in Route 53):

```bash
terraform apply \
  -var="bucket_name=your-unique-bucket-name" \
  -var="domain_name=example.com" \
  -var="hosted_zone_id=Z0123456789ABCDEF"
```

## Wire up CI/CD

`.github/workflows/deploy.yml` plans on every PR and applies on every push to
`main`, then invalidates the CloudFront cache so changes show up immediately.
It expects one repo secret:

- `AWS_ROLE_ARN` — an IAM role your GitHub Actions runner can assume via OIDC
  (avoid long-lived access keys in CI)

## Tear it down

```bash
terraform destroy
```

## Project structure

```
.
├── site/                 # the static website (HTML/CSS/JS, no build step)
│   └── index.html
├── terraform/            # all infrastructure
│   ├── versions.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
└── .github/workflows/
    └── deploy.yml        # plan on PR, apply on push to main
```

## Ideas to extend this practice project

- Add remote state: an S3 backend bucket + DynamoDB lock table (stubbed out in `versions.tf`)
- Split into modules (`modules/static-site`) so it's reusable across environments
- Add a `staging` workspace alongside `production`
- Swap the S3+CloudFront pattern for an ECS Fargate + ALB app to practice compute instead of static hosting
