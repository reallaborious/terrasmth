terraform {
  source = "../../../terraform/elementary_modules/azure/public_ip"
}

include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

# Dependencies
dependencies {
  paths = [
    "../resource_group"
  ]
}

dependency "resource_group" {
  config_path = "../resource_group"
  mock_outputs = {
    resource_group_name = "mock-rg"
  }
}

inputs = {
  # Basic configuration
  public_ip_name      = "${local.config.locals.project_name}-build-vm-ip"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = local.config.locals.location
  
  # Public IP configuration
  allocation_method = "Static"
  sku               = "Standard"
}