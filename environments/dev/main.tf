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

module "env" {
  source = "../../"
  stage  = "dev"
}

output "key_path" {
  value = module.env.private_key_path
}

output "ip" {
  value = module.env.instance_ip
}

output "inventory" {
  value = module.env.inventory
}

output "ansible_command" {
  value = module.env.ansible_command
}
