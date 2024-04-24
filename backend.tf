terraform {
  backend "s3" {
    bucket = "backend-s3project"                         
    key    = "project1/terraform.tfstate"
    region = "us-east-1"
  }
}