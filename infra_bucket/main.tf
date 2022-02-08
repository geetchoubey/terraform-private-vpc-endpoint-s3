terraform {
  required_version = "1.1.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

module "s3_bucket" {
  source = "./bucket"
  bucket_name = var.bucket_name
  secondary_aws_account = var.secondary_aws_account
  region = var.region
}