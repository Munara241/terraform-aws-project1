provider aws {
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

# resource "aws_s3_bucket_accelerate_configuration" "config" {
#   bucket = aws_s3_bucket.website_bucket.id
#   status = "Enabled"
# }


# resource "aws_s3_bucket_policy" "allow_access" {
#   bucket = aws_s3_bucket.website_bucket.id
#   policy = data.aws_iam_policy_document.allow_access.json
# }

# data "aws_iam_policy_document" "allow_access" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["123456789012"]
#     }
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]
#     resources = [
#       aws_s3_bucket.website_bucket.arn,
#       "${aws_s3_bucket.website_bucket.arn}/*",
#     ]
#   }
# }



# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.www_bucket.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = "*"
#         Action = [
#           "s3:GetObject"
#         ]
#         Resource = [
#           "${aws_s3_bucket.www_bucket.arn}/*"
#         ]
#       }
#     ]
#   })
# }



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
  depends_on = [aws_s3_bucket_acl.acl]
  bucket = aws_s3_bucket.website_bucket.id       #not sure
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  depends_on = [aws_s3_bucket_acl.acl]
  bucket = aws_s3_bucket.website_bucket.id     
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_route53_record" "web" {
  zone_id = "Z0558387567WQ24W7LRY"    # Provide hosted zone ID
  name    = var.bucket_name
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_s3_bucket.website_bucket.bucket}.s3-website.${var.region}.amazonaws.com"]
}


#["${aws_s3_bucket.website_bucket.bucket}.s3-website.${var.region}.amazonaws.com"]
# resource "aws_route53_record" "website_record" {
#   zone_id = "Z0558387567WQ24W7LRY"
#   name    = var.subdomain_name
#   type    = "NS"
#   ttl     = "300"
# } 
