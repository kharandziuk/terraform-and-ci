from invoke import task
from pathlib import Path
from dotenv import load_dotenv
import os
load_dotenv()

CUR_DIR = Path(".")
ENV_DIR = CUR_DIR / "environments" / "dev"

@task
def apply_infrastructure(c):
    c.run(f"cd {ENV_DIR} && terraform init --reconfigure && terraform apply --auto-approve")

@task(apply_infrastructure)
def output_inventory(c):
    c.run(f"cd {ENV_DIR} && terraform output inventory > {(CUR_DIR / 'inventory.yml' )}")

@task(output_inventory)
def provision(c):
     c.run('ansible-playbook -i inventory.yml playbook.yml')

@task
def destroy_infrastructure(c):
    c.run(f"cd {ENV_DIR} && terraform init --reconfigure && terraform destroy --auto-approve")
