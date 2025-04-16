Jenkins CI/CD Pipeline for AWS Infrastructure Automation

Jenkins CI/CD Pipeline for AWS Infrastructure Automation
This project automates the provisioning, configuration, deployment, and security scanning of cloud infrastructure using a powerful Jenkins pipeline integrated with industry-standard tools like Terraform, Packer, Ansible, Docker, and OWASP ZAP.

The pipeline is designed for multi-environment support (Development & Production) and follows a modular, parameterized approach to ensure flexibility, security, and full automation.

📦 Features
🔁 Parallel Dev & Prod Deployments

🌩️ Infrastructure as Code using Terraform

📦 Packer-based AMI image creation

⚙️ Ansible-based configuration management and provisioning

🐳 Dockerized application deployment

🔒 DAST Security Scanning with OWASP ZAP

🧪 Syntax check & dry run support before actual Ansible execution

✅ Approval step before destructive actions (like terraform destroy)

📢 Slack integration for real-time pipeline status notifications

🛠️ Tech Stack
Tool	Purpose
Jenkins	CI/CD orchestration and pipeline runner
Terraform	Infrastructure provisioning on AWS
Packer	AMI creation with base configurations
Ansible	Configuration management & deployment
Docker	Containerized application support
OWASP ZAP	Security vulnerability scanning (DAST)
Slack	Notifications for pipeline events
🧩 Pipeline Breakdown
✅ Trigger Conditions
Deploys to Development on development branch

Deploys to Production on production branch

🧪 Stages Overview
1. 🧰 Packer AMI Build (Conditional)
Creates custom AMIs with application/environment-specific setup

Controlled via PACKER_ACTION (YES/NO)

2. ☁️ Terraform Plan & Apply (Conditional)
Provisions infrastructure in AWS based on environment

Controlled via TERRAFORM_APPLY (YES/NO)

3. 🛡️ Ansible Playbook Execution (Conditional)
Pre-run syntax check and dry-run mode

Executes Docker Swarm deployment

Controlled via ANSIBLE_ACTION (YES/NO)

4. 🔍 DAST Security Scan with OWASP ZAP (Conditional)
Scans the deployed app for security vulnerabilities

Uses zaproxy/zap-stable Docker image

Triggered if ANSIBLE_ACTION is YES

5. 👮 Approval Step
Manual approval gate before destroying infrastructure

6. 🧨 Terraform Destroy
Clean-up phase to tear down the infrastructure
