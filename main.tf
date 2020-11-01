locals {
  tmp_path         = abspath("${path.module}/.terraform/tmp")
  private_key_path = "${local.tmp_path}/key_rsa"
  inventory_content = templatefile(
    "${path.module}/inventory.tpl",
    {
      ip_addrs : [module.instance.public_ip],
      private_key_path : local.private_key_path
    }
  )
  inventory_path = "${local.tmp_path}/inventory.yml"
  playbook_path  = abspath("${path.module}/playbook.yml")
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "inventory_path" {
  content         = local.inventory_content
  filename        = local.inventory_path
  file_permission = "0600"
}

resource "local_file" "private_key" {
  content         = tls_private_key.default.private_key_pem
  filename        = local.private_key_path
  file_permission = "0600"
}

variable "stage" {
  description = "Stage. e.g.:dev, prod, staging"
}


module "instance" {
  description = "${var.stage} terraform and ci"
  # TODO: use exact version
  source     = "git::https://github.com/kharandziuk/aws-ec2-bootstrap.git"
  public_key = tls_private_key.default.public_key_openssh
}

output "inventory" {
  value = local.inventory_content
}

output "ansible_command" {
  value = "ansible-playbook -i ${local.inventory_path} ${local.playbook_path}"
}

output "ssh_command" {
  value = "ssh -i ${local.private_key_path} ubuntu@${module.instance.public_ip}"
}

output "private_key_path" {
  value = abspath(local.private_key_path)
}

output "instance_ip" {
  value = module.instance.public_ip
}

