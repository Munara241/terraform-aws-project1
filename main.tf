provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "own" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.own,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  depends_on   = [aws_s3_bucket_acl.acl]
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  depends_on   = [aws_s3_bucket_acl.acl]
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_route53_record" "web" {
  # Provide hosted zone ID
  zone_id = var.zone_id
  name    = var.bucket_name
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_s3_bucket.website_bucket.bucket}.s3-website.${var.region}.amazonaws.com"]
}
# bucket-name.s3-website.region.amazonaws.com (endpoint)
