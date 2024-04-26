module "s3_hosting_website" {
  source = "Munara241/project1/aws"
  version = "0.0.3"
  region = "us-east-2"
  bucket_name = "hello.munara241.com"
  subdomain_name = "hello.munara241.com"
  zone_id = "Z0558387567WQ24W7LRY"
}