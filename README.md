### AWS S3 Static Website

# This Terraform module provides the required infrastructure to host a static website on S3.


## Resourses

Name

[aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

[aws_s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)

[aws_s3_bucket_ownership_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) 

[aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)

[ aws_s3_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)

[aws_s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)

[aws_s3_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_object)

[ aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)



## Remote backend configuration

Configure your Terraform backend to store the statefile remotely. For example, using an S3 bucket with Prevent_destroy option so Terraform will be not allowed to delete the bucket by "terraform destroy" command. To be able to see all versions of statefiles(changes) you need versioning configuration
This resource should be applied first to create a bucket
```hcl
provider "aws" {
  region = "<region>"
}
resource "aws_s3_bucket" "backendfile" {
  bucket = "<state_bucket_name>"
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


Then according to just created state bucket provide following requirements 
backend.tf

```hcl
 terraform {
   backend "s3" {
     bucket = "<same as state_bucket_name>"                          
     key    = "terraform/state"       
     region = "<state_bucket_region>"
   }
 }
 ```


Before deploying module structure create index.html and error.html files, index.html contains information about your website


### Module Structure

The module is structured as follows:

```hcl
module "s3_hosting_website" {
  source = "Munara241/project1/aws"
  version = "0.0.5"
  region = ""         # Provide the region 
  subdomain_name = "" # Provide the your subdomain 
  bucket_name = ""    # Provide the bucket name same as subdomain #123.example.com
  zone_id = ""        # Provide you zone_id taken from route53
}
```

# Access the Website
Once the deployment is complete, access the website by navigating to the specified subdomain in web browser.

