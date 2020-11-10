variable "access_key" {
  description = "Access key to your AWS account "
}

variable "secret_key" {
  description = "Secret key to your AWS account "
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

module "env" {
  source = "../../"
  stage  = "staging"
}

output "inventory" {
  value = module.env.inventory
}

output "ansible_command" {
  value = module.env.ansible_command
}
