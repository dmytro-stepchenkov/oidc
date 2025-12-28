variable "common_providers" {
  type    = list(string)
  default = []
}

variable "custom_providers" {
  type = map(object({
    name              = optional(string, null)
    url               = string
    client_id_list    = list(string)
    thumbprint_list   = optional(list(string), [])
    lookup_thumbprint = optional(bool, true)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "provider_tags" {
  type    = map(map(string))
  default = {}
}

variable "workspace_uuid" {
  type    = string
  default = ""
}

variable "workspace_name" {
  type    = string
  default = ""
}

variable "rule_name" {
  type = string
}

variable "rule_description" {
  type = string
}

variable "rule_repository" {
  type = string
}

variable "rule_account_id" {
  type    = string
  default = null
}

variable "rule_common_provider" {
  type    = string
  default = "github"
}

variable "rule_custom_provider" {
  type = object({
    url                    = string
    audiences              = list(string)
    subject_reader_mapping = string
    subject_branch_mapping = string
    subject_env_mapping    = string
    subject_tag_mapping    = string
  })
  default = null
}

variable "rule_additional_audiences" {
  type    = list(string)
  default = []
}

variable "rule_protected_by" {
  type = object({
    branch      = optional(string)
    environment = optional(string)
    tag         = optional(string)
  })
  default = {
    branch      = "main"
    environment = "production"
    tag         = "*"
  }
}

variable "rule_role_path" {
  type    = string
  default = null
}

variable "rule_default_managed_policies" {
  type    = list(string)
  default = []
}

variable "rule_default_inline_policies" {
  type    = map(string)
  default = {}
}

variable "rule_read_only_policy_arns" {
  type    = list(string)
  default = []
}

variable "rule_read_only_inline_policies" {
  type    = map(string)
  default = {}
}

variable "rule_read_write_policy_arns" {
  type    = list(string)
  default = []
}

variable "rule_read_write_inline_policies" {
  type    = map(string)
  default = {}
}

variable "rule_read_only_max_session_duration" {
  type    = number
  default = null
}

variable "rule_read_write_max_session_duration" {
  type    = number
  default = null
}

variable "rule_force_detach_policies" {
  type    = bool
  default = null
}

variable "rule_permission_boundary" {
  type    = string
  default = null
}

variable "rule_permission_boundary_arn" {
  type    = string
  default = null
}

variable "rule_tags" {
  type    = map(string)
  default = {}
}
