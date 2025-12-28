data "aws_caller_identity" "current" {}

module "oidc_provider" {
  source = "./modules/oidc-provider"

  common_providers = var.common_providers
  custom_providers = var.custom_providers

  tags          = var.tags
  provider_tags = var.provider_tags

  workspace_uuid = var.workspace_uuid
  workspace_name = var.workspace_name
}

module "oidc_rule" {
  source = "./modules/oidc-rule"

  name        = var.rule_name
  description = var.rule_description
  repository  = var.rule_repository

  account_id = coalesce(var.rule_account_id, data.aws_caller_identity.current.account_id)

  common_provider = var.rule_common_provider
  custom_provider = var.rule_custom_provider

  additional_audiences = var.rule_additional_audiences
  protected_by         = var.rule_protected_by
  role_path            = var.rule_role_path

  default_managed_policies = var.rule_default_managed_policies
  default_inline_policies  = var.rule_default_inline_policies

  read_only_policy_arns     = var.rule_read_only_policy_arns
  read_only_inline_policies = var.rule_read_only_inline_policies
  read_write_policy_arns    = var.rule_read_write_policy_arns
  read_write_inline_policies = var.rule_read_write_inline_policies

  read_only_max_session_duration  = var.rule_read_only_max_session_duration
  read_write_max_session_duration = var.rule_read_write_max_session_duration

  force_detach_policies   = var.rule_force_detach_policies
  permission_boundary     = var.rule_permission_boundary
  permission_boundary_arn = var.rule_permission_boundary_arn

  tags = var.rule_tags

  depends_on = [module.oidc_provider]
}
