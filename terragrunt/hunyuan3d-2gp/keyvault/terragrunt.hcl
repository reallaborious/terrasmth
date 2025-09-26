include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/keyvault"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

dependency "resource_group" {
  config_path = "../resource_group"
}

inputs = {
  keyvault_name       = "${local.config.locals.project_name}-kv"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location           = local.config.locals.location
  subscription_id    = local.config.locals.subscription_id
  tenant_id          = local.config.locals.tenant_id
  
  sku_name = "standard"
  
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  
  purge_protection_enabled = false
  soft_delete_retention_days = 7
  
  tags = merge(local.config.locals.common_tags, {
    Component = "KeyVault"
    Purpose   = "SecretManagement"
  })
}