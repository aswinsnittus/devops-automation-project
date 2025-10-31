cd C:\Users\aswin\devops-project

# create .gitignore
@'
# Node
app/node_modules/
app/.env
# local builds
dist/
build/
# system
.DS_Store
Thumbs.db
# keys and credentials
*.pem
*.key
.aws/
# logs
*.log
'@ | Out-File -Encoding utf8 .gitignore

# create README if not present
if (-not (Test-Path README.md)) {
@'
# DevOps Automation Project

Karunya University — DevOps project (Docker + Terraform + Ansible).
'@ | Out-File -Encoding utf8 README.md
}
