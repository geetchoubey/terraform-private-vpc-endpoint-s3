variable "ami" {
  type    = string
  default = "ami-0a8b4cd432b1c3063"
}

variable "key_pair_name" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "private_sg" {
  type = string
}

variable "region" {
  type = string
}