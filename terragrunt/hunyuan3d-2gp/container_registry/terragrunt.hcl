include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/container_registry"
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
  name                = "${replace(local.config.locals.project_name, "-", "")}acr"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location           = local.config.locals.location
  
  sku                 = "Standard"
  admin_enabled       = true
  public_network_access_enabled = true
  
  # retention_policy only available for Premium SKU
  # retention_policy = {
  #   enabled = true
  #   days    = 30
  # }
  
  trust_policy = {
    enabled = false
  }
  
  tags = merge(local.config.locals.common_tags, {
    Component = "ContainerRegistry"
    Purpose   = "ImageStorage"
  })
}