# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform/OpenTofu that provides extra tools for working with multiple modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  aws_profile  = get_env("TG_AWS_PROFILE", "default")
  aws_region   = get_env("TG_AWS_REGION", "")
  account_id   = get_env("TG_AWS_ACCOUNT_ID", "")
  environment  = get_env("TG_ENVIRONMENT", "")
  project_name = get_env("TG_PROJECT_NAME", "")

  rule_name        = get_env("TG_RULE_NAME", "")
  rule_description = get_env("TG_RULE_DESCRIPTION", "")

  _validate_rule_name = length(local.rule_name) > 0 ? true : (
    throw("TG_RULE_NAME is required")
  )
  _validate_rule_description = length(local.rule_description) > 0 ? true : (
    throw("TG_RULE_DESCRIPTION is required")
  )

  default_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "terragrunt"
    Owner       = "platform"
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.aws_region}"
  profile = "${local.aws_profile}"

  default_tags {
    tags = ${jsonencode(local.default_tags)}
  }

  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    profile        = local.aws_profile
    encrypt        = true
    bucket         = "terraform-st-acc-${local.account_id}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  common_providers = ["github"]
  custom_providers = {}
  tags = {
    Name = "oidc"
  }

  rule_name        = local.rule_name
  rule_description = local.rule_description
  rule_repository = get_env("TG_RULE_REPOSITORY", "")

  rule_common_provider = "github"
  rule_tags = {
    Name = "github-actions-oidc"
  }

  rule_account_id = local.account_id
}