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

module "networking" {
  source              = "./network"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  subnet_az           = var.subnet_az
}

module "instances" {
  source            = "./instance"
  key_pair_name     = "my_key_pair"
  private_sg        = module.networking.private_sg
  public_sg         = module.networking.public_sg
  private_subnet_id = module.networking.private_subnet_id
  public_subnet_id  = module.networking.public_subnet_id
}