include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/resource_group"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

inputs = {
  rg_name         = "${local.config.locals.project_name}-rg"
  location        = local.config.locals.location
  subscription_id = local.config.locals.subscription_id
  tags           = merge(local.config.locals.common_tags, {
    Component = "ResourceGroup"
  })
}