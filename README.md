# Terragrunt: OIDC Provider + IAM Role (Rule)

## Architecture
![Architecture diagram](diagram.svg)

This repository provisions:
- An **AWS IAM OIDC Provider** (e.g., GitHub)
- An **IAM Role** trusted by that OIDC provider (e.g., for GitHub Actions)

Terragrunt is used to:
- Generate AWS provider configuration (`provider.tf`)
- Configure remote state in **S3** (`backend.tf`)
- Provide inputs to the Terraform root module that orchestrates both modules in the correct order

---

## Prerequisites

- **Terraform** (or OpenTofu)
- **Terragrunt**
- AWS credentials available locally (AWS CLI configured)
  - via `AWS_PROFILE` / SSO or environment-based credentials

---

## Configuration via env file (recommended)

To avoid committing account/region/project details into a public repository, configuration is passed via environment variables.

### 1) Create a local env file

Create `terragrunt.env` (do **not** commit):

```env
TG_AWS_PROFILE=myproject
TG_AWS_ACCOUNT_ID=123456789012
TG_AWS_REGION=us-east-1
TG_ENVIRONMENT=dev
TG_PROJECT_NAME=oidc

TG_RULE_REPOSITORY=ORG/REPO
TG_RULE_NAME=github-actions-oidc
TG_RULE_DESCRIPTION=GitHub Actions OIDC role
```
Load it:
```set -a; source terragrunt.env; set +a```

###  2) Backend bootstrap (S3 state)
Terraform S3 backend requires the bucket to exist before init.
Terragrunt can create the backend automatically from your remote_state configuration.
Run bootstrap once:
```terragrunt backend bootstrap```

If you have multiple Terragrunt units under the current directory, use:
```terragrunt backend bootstrap --all```

### Locking:
- If your remote_state uses dynamodb_table, Terragrunt will create/expect that DynamoDB table.
- If your remote_state uses use_lockfile = true, DynamoDB is not required.

### 3) How to run
After bootstrap:
```
terragrunt init
terragrunt plan
terragrunt apply
```

## One-command run
This will bootstrap backend automatically and then apply:
```terragrunt apply --backend-bootstrap```
