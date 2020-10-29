
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




module "instance" {
  description = "terraform and ci"
  # TODO: use exact version
  source     = "git::https://github.com/kharandziuk/aws-ec2-bootstrap.git"
  public_key = tls_private_key.default.public_key_openssh
}


output "run_ansible_command" {
  value = local.ansible_command_engine
}

output "ssh_command" {
  value = "ssh -i ${local.public_key_path} ubuntu@${module.instance.public_ip}"
}
