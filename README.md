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



## Statefile should be stored in a remote backend.
First of all we have to create the S3 bucket in another region to store our state file.


```hcl

module "s3_hosting_website" {
  source = "Munara241/project1/aws"
  version = "0.0.3"
  region = "us-east-2"
  bucket_name = "hello.munara241.com"
  subdomain_name = "hello.munara241.com"
  zone_id = "Z0558387567WQ24W7LRY"
}
```