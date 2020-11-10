variable "access_key" {
  description = "Access key to your AWS account"
}

variable "secret_key" {
  description = "Secret key to your AWS account"
}

variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_s3_bucket" "state" {
  bucket = "${var.project_name}-states"
  acl    = "private"
}
