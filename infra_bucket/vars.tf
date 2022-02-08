variable "region" {
  type = string
  default = "us-east-1"
}

variable "bucket_name" {
  type = string
  description = "S3 Bucket Name"
}

variable "secondary_aws_account" {
  type = string
}