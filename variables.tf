variable "region" {
  type        = string
  description = "Provide region"
}

variable "bucket_name" {
  type        = string
  description = "Provide S3 bucket name"
}

variable "subdomain_name" {
  type        = string
  description = "Provide subdomain name for Route53 record"
}
