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

locals {
  tmp_path               = "${path.module}/.terraform/tmp"
  public_key_path        = "${local.tmp_path}/key_rsa"
  ansible_command_engine = "ansible-playbook -i ${module.instance.public_ip}, --user ubuntu --private-key ${local.public_key_path} playbook.yml"
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "private_key" {
  content         = tls_private_key.default.private_key_pem
  filename        = local.public_key_path
  file_permission = "0600"
}


provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


module "instance" {
  description = "terraform and ci"
  source      = "git@github.com:kharandziuk/aws-ec2-bootstrap.git"
  public_key  = tls_private_key.default.public_key_openssh
}


output "run_ansible_command" {
  value = local.ansible_command_engine
}

output "ssh_command" {
  value = "ssh -i ${local.public_key_path} ubuntu@${module.instance.public_ip}"
}
