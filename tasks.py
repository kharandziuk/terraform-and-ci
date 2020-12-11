from invoke import task
from pathlib import Path
from dotenv import load_dotenv
import os
load_dotenv()

CUR_DIR = Path(".")

# return the name of environent depending on the ENV vars
def _which_environment():
    if os.getenv("DEPLOYMENT_ENV"):
        return os.getenv("DEPLOYMENT_ENV")
    if os.getenv("GITHUB_EVENT_NAME") == "push":
        return 'staging'
    return "dev"

ENV_DIR = CUR_DIR / "environments" / _which_environment()

inventory_path = (CUR_DIR / 'inventory.yml').absolute()

print(ENV_DIR)

@task
def which_environment(c):
    c.run(f"echo '{_which_environment()}'")

@task
def apply(c):
    c.run(
        f"terraform -chdir={ENV_DIR} init --reconfigure && terraform -chdir={ENV_DIR} apply --auto-approve"
    )

@task(apply_infrastructure)
def output_inventory(c):
    c.run(
        f"terraform -chdir={ENV_DIR} output -json inventory | jq -r . > {inventory_path}"
    )

@task(output_inventory)
def provision(c):
    c.run(f"ansible-playbook -i inventory.yml playbook.yml")

@task
def destroy(c):
    c.run(
        f"terraform -chdir={ENV_DIR} init --reconfigure && terraform -chdir={ENV_DIR} destroy --auto-approve"
    )

@task(provision)
def all(c):
    pass
