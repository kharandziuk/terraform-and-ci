run-playbook: inventory.yml
	ansible-playbook -i inventory.yml playbook.yml

inventory.yml: terraform-apply
	cd environments/dev && terraform output inventory > ../../inventory.yml
.PHONY: terraform-apply
terraform-apply:
	cd environments/dev && terraform init && terraform apply --auto-approve

.PHONY: terraform-destroy
terraform-destroy:
	cd environments/dev && terraform init && terraform destroy --auto-approve

