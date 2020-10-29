variable "aws_access_key" {
  description = "Access key to your AWS account "
}

variable "aws_secret_key" {
  description = "Secret key to your AWS account "
}

variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region"
}

provider "aws" {
  region = var.aws_region
}

module "dev_env" {
  source = "../"
}
