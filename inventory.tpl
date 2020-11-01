---
all:
  hosts:
  %{ for addr in ip_addrs ~}
    ${addr}:
  %{ endfor ~}

  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ${private_key_path}
