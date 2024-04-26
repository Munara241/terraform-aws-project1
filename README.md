# terraform-aws-project1
## Write a Terraform Code that creates a bucket and host static website in it. 

Index.html and error.html should be for a restaurant menu.
Add Route53 record and access your website in a browser with subdomain.
Make your code dynamic and create variables and tfvars.
Statefile should be stored in a remote backend.
Create module from your code and push to Terraform registry with Readme 
file.
Create documentation with GitHub link and provide hours for each team 
member.

# Statefile should be stored in a remote backend.
First of all we have to create the backend-S3 bucket in different region to store our state files.
Use this code:
```hcl
provider "aws" {
  region = "" # provide region
}
resource "aws_s3_bucket" "backendfile" {
  bucket = "<name of S3 bucket>"
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
```
After creating S3 bucket you have to attach it to store your statefile.

Use code:

```hcl
 terraform {
   backend "s3" {
     bucket = "<name of S3 bucket>"                          
     key    = "project1/terraform.tfstate"
     region = "us-east-1"
   }
 }
 ```
# Module Structure
Before deploying module structure need to create own index.html and error.html files.

The module is structured as follows:

```hcl
module "s3_hosting_website" {
  source = "Munara241/project1/aws"
  version = "0.0.5"
  region = "" # Provide the region
  bucket_name = ""  # provide the bucket name like subdomain example.anything.com
  subdomain_name = "" # provide the subdomain
  zone_id = "" # provide you zone_id
}
```

# Access the Website
Once the deployment is complete, access the restaurant website by navigating to the specified subdomain in your web browser.
