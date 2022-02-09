variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "subnet_az" {
  type = string
}

variable "vpc_endpoints" {
  default = [
    "ssm",
    "ec2messages",
    "ec2",
    "ssmmessages"
  ]
}