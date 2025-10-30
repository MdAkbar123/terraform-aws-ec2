# terraform-aws-ec2

Infrastructure-as-Code example: provision an AWS EC2 (Ubuntu) instance with Terraform and configure it with Ansible to install and run Nginx.

## Overview
- Terraform: provisions VPC/subnet, security group, key pair (or reuse), and an EC2 instance. Outputs the instance public IP.
- Ansible: connects via SSH to the instance, installs and enables Nginx, and ensures the service is running.
- Objective: demonstrate a reproducible DevOps pipeline: Terraform → Infrastructure, Ansible → Configuration.

## Repo layout
terraform-aws-ec2/
├── main.tf
├── variables.tf
├── outputs.tf
├── data-network.tf
├── instance.tf
├── terraform.tfstate
├── ansible/
│   ├── ansible.cfg
│   ├── playbook.yml
│   └── inventory.ini
└── README.md

## Prerequisites
- Terraform (v1.x recommended)
- Ansible (2.9+ or 2.10+)
- AWS CLI configured with credentials and default region
- An SSH private key available (e.g. `~/.ssh/id_rsa`) and corresponding public key registered with Terraform or AWS
- Network access to EC2 public IP (security group allowing SSH and HTTP)

## Terraform: quick usage
1. Initialize:
    terraform init

2. Format / validate:
    terraform fmt
    terraform validate

3. Plan:
    terraform plan -out=tfplan

4. Apply:
    terraform apply tfplan

5. View outputs:
    terraform output
    (Example output variable expected: `public_ip` — adjust if named differently)

6. Destroy when done:
    terraform destroy -auto-approve

Files purpose:
- main.tf / instance.tf: resources (VPC/subnet/security group/instance)
- variables.tf: configurable inputs
- outputs.tf: exposes instance public IP (and any other info)
- data-network.tf: data sources for networking (if reusing default VPC/subnet)

Example: generate Ansible inventory using Terraform output (adjust output name if different)
- Bash:
  echo -e "[webserver]\n$(terraform output -raw public_ip) ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" > ansible/inventory.ini

## Ansible: quick usage
Example ansible.cfg (repo has one):
[defaults]
inventory = ./inventory.ini
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
interpreter_python = auto

Example inventory.ini (generated from Terraform output):
[webserver]
18.204.123.45 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

Playbook (repo: ansible/playbook.yml) installs and ensures Nginx:
- Update apt cache
- Install nginx
- Ensure nginx service is started and enabled

Commands:
- Check inventory:
  ansible-inventory -i ansible/inventory.ini --list

- Connectivity test:
  ansible all -m ping -i ansible/inventory.ini

- Run playbook:
  ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

## Cleanup
- Remove AWS resources:
  terraform destroy -auto-approve

- Remove local state (optional):
  rm -f terraform.tfstate terraform.tfstate.backup

## Security notes
- Store AWS credentials and private keys securely (avoid committing to repo).
- Use least-privilege AWS IAM credentials for Terraform.
- Lock down security group rules (restrict SSH to trusted IPs).

## Troubleshooting
- SSH fails: verify security group, correct key, and `ubuntu` user for Ubuntu AMIs.
- Terraform errors: run `terraform fmt` and `terraform validate`, check provider versions.
- Ansible unreachable: verify public IP, network ACLs, and host_key_checking disabled in ansible.cfg.

## Next steps / Improvements
- Use Terraform provisioner or null_resource with local-exec to auto-generate inventory after apply.
- Replace static key with AWS EC2 Key Pair resource managed by Terraform.
- Use dynamic inventory (terraform-inventory or an external script) for larger fleets.
- Add Terraform modules and state backend (S3 + DynamoDB) for team usage.

License: MIT (or replace with your preferred license)