provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "backendfile" {
  bucket = "backend-s3project"
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.backendfile.id
    versioning_configuration {
      status = "Enabled"
    }
}