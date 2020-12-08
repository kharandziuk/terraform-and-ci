ENV?=dev

run-playbook: inventory.yml
	ansible-playbook -i inventory.yml playbook.yml

inventory.yml: terraform-apply
	cd environments/$(ENV) && terraform output inventory > ../../inventory.yml
.PHONY: terraform-apply
terraform-apply:
	cd environments/$(ENV) && terraform init && terraform apply --auto-approve

.PHONY: terraform-destroy
terraform-destroy:
	cd environments/$(ENV) && terraform init && terraform destroy --auto-approve

