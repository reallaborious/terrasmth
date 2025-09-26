include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/virtual_network"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

dependency "resource_group" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "hunyuan3d-2gp-rg"
    location           = "eastus"
  }
}

inputs = {
  vnet_name      = "${local.config.locals.project_name}-vnet"
  rg_name        = dependency.resource_group.outputs.resource_group_name
  location       = local.config.locals.location
  subscription_id = local.config.locals.subscription_id
  
  address_space    = ["10.0.0.0/16"]
  subnet_names     = ["container-subnet"]
  subnet_prefixes  = ["10.0.1.0/24"]
  
  tags = merge(local.config.locals.common_tags, {
    Component = "VirtualNetwork"
  })
}