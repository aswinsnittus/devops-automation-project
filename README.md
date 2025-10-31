# Karunya University — DevOps Automation Project

**Project:** DevOps Automation Demo  
**Author:** Aswin SNITTU  
**GitHub:** https://github.com/aswinsnittus/devops-automation-project  
**Docker Hub:** `aswinsnittu/devops-ui`  
**Live demo:** `http://<PUBLIC_IP>/` *(replace `<PUBLIC_IP>` with Terraform output)*

---

## Project Overview

This project demonstrates a full DevOps workflow and tooling pipeline:

- A small **Node.js** web UI (Express) used as the demo application.
- **Containerized** with Docker.
- Docker images are published to **Docker Hub**.
- Infrastructure provisioning is performed with **Terraform** (AWS EC2 + Security Group).
- Server configuration & application deployment can be done with **Ansible** (idempotent playbook).
- Optional: **GitHub Actions** CI workflow builds & pushes Docker images on each push to `main`.

This repository contains all source code, infrastructure-as-code, and automation scripts required to reproduce the demo.

---

## Repository Structure

/app
├─ server.js
├─ package.json
└─ public/index.html # Modern UI (Karunya University landing page)

Dockerfile
README.md
.github/
└─ workflows/
└─ docker-build-push.yml
/terraform
├─ main.tf
├─ variables.tf
├─ outputs.tf
└─ user_data.sh # optional: EC2 bootstrap script
/ansible
├─ inventory.ini
└─ deploy.yml

yaml
Copy code

---

## Quick demo — what to show

When demoing the project, present:

1. GitHub repo with commits and README (this file).
2. Docker Hub repo: `aswinsnittu/devops-ui` — show tags (v1.0.2, latest).
3. Terraform `apply` output (shows `public_ip`).
4. Live app running at `http://<PUBLIC_IP>/` (open in browser).
5. SSH to EC2 to run:
   ```bash
   ssh -i "<path-to-devops-key.pem>" ubuntu@<PUBLIC_IP>
   sudo docker ps
   sudo docker logs devops-ui --tail 50
(Optional) Run Ansible playbook to show idempotent steps.

How to run locally (development)
Prerequisites
Node.js (v18+ recommended)

npm

Docker (if you want to run in container)

Git

Start dev server
powershell
Copy code
cd app
npm install
npm start
# Open http://localhost:8080
Build & run with Docker (local)
powershell
Copy code
# from project root
docker build -t aswinsnittu/devops-ui:local .
docker run -d --name devops-ui-local -p 8080:8080 aswinsnittu/devops-ui:local
# open http://localhost:8080
Docker Hub: build & push
Local manual push:

powershell
Copy code
# tag and push
docker build -t aswinsnittu/devops-ui:v1.0.2 .
docker tag aswinsnittu/devops-ui:v1.0.2 aswinsnittu/devops-ui:latest
docker login
docker push aswinsnittu/devops-ui:v1.0.2
docker push aswinsnittu/devops-ui:latest
If you enable GitHub Actions (see below), pushing to main will automatically build and push images.

Terraform — infrastructure
Note: Terraform state files and provider binaries are ignored from the repository. Do not commit .terraform/ or provider executables.

Example (from terraform folder)
powershell
Copy code
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
Outputs will include:

public_ip — the EC2 instance public IP (use this to open the UI).

instance_id — the created EC2 id.

user_data: This repo includes user_data.sh (or the user_data block in main.tf) which will install Docker and run the container on first boot. If you recreate the instance, the container will be bootstrapped automatically.

Ansible — server configuration (optional)
An idempotent playbook is provided to install Docker, pull the image, and run the container.

Run from WSL / Linux host:
bash
Copy code
# install collection once
ansible-galaxy collection install community.docker

ansible-playbook -i ansible/inventory.ini ansible/deploy.yml -u ubuntu
inventory.ini should point to your EC2 public IP and use the .pem key path.

GitHub Actions (CI) — Build & Push Docker image
A workflow is included in .github/workflows/docker-build-push.yml that triggers on pushes to main.
It only builds & pushes the Docker image (it does NOT run Terraform or modify live infrastructure).

Required repository secrets:

DOCKERHUB_USERNAME — your Docker Hub username (aswinsnittu)

DOCKERHUB_TOKEN — Docker Hub access token (create in Docker Hub → Account → Security → New Access Token)

How to enable:

Add the two secrets in GitHub repo settings → Secrets and variables → Actions.

Push to main. The workflow will run and the Docker image will be pushed to Docker Hub.

Security notes (IMPORTANT)
Never commit private keys (*.pem), AWS credentials, or tokens to the repository.

Use .gitignore to exclude:

.terraform/

*.pem

*.key

app/node_modules/

.aws/ and credentials

If you ever accidentally commit a secret, revoke it immediately and remove it from the repo history.

The project’s CI workflow uses GitHub Secrets — store tokens there (not in files).

How to update the live server with a new image (manual safe step)
When CI pushes a new image tag (or you push manually), update the EC2 container via SSH (manual control avoids unintended infra changes):

bash
Copy code
ssh -i "<path-to-devops-key.pem>" ubuntu@<PUBLIC_IP>
sudo docker pull aswinsnittu/devops-ui:latest
sudo docker rm -f devops-ui 2>/dev/null || true
sudo docker run -d --name devops-ui --restart unless-stopped -p 80:8080 aswinsnittu/devops-ui:latest
This approach ensures you control when the running instance is updated.

Rubric mapping (how this meets evaluation criteria)
Source Control — Repository with commits and README.

Containerization — Dockerfile and Docker Hub image.

Infrastructure as Code — Terraform config to provision EC2 and SG.

Configuration Management — Ansible playbook to install Docker & run container (idempotent).

CI/CD — GitHub Actions builds and pushes Docker image automatically.

Validation & Monitoring — Container logs (docker logs) and HTTP health endpoints to verify runtime.

This project demonstrates end-to-end DevOps principles and can be reproduced by following the steps above.

Troubleshooting
Push rejected due to large files: Remove .terraform/ and provider binaries locally and ensure .gitignore prevents them from being added.

Secret push blocked: If a token is accidentally committed, revoke it immediately, remove it from history, and re-push a clean commit.

Port conflicts: If localhost:8080 conflicts, stop the container binding that port or use a different host port (e.g., -p 8081:8080).

Useful commands
bash
Copy code
# Docker
docker ps
docker logs -f devops-ui
docker rm -f devops-ui

# Terraform
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

# Git
git add .
git commit -m "message"
git push origin main
Screenshots & Evidence (for submission)
Include the following screenshots in your report:

Browser showing http://<PUBLIC_IP>/ (new UI).

docker ps output on EC2.

docker logs devops-ui showing Server running on port 8080.

Terraform apply output showing public_ip.

GitHub Actions run (success) and Docker Hub tags page.

Contact / Acknowledgements
Author: Aswin SNITTU

University: Karunya Institute of Technology & Sciences

For questions or clarifications — include your contact or submit via course channel.

pgsql
Copy code
