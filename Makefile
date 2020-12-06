run-playbook: inventory.yml
	ansible-playbook -i inventory.yml playbook.yml

inventory.yml: terraform-apply
	cd environments/dev && terraform output inventory > ../../inventory.yml

.PHONY: terraform-apply
terraform-apply:
	cd environments/dev && terraform apply --auto-approve

terraform-destroy:
	cd environments/dev && terraform destroy --auto-approve
