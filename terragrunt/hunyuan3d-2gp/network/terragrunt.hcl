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
  
  address_space    = ["10.0.0.0/16"]
  subnet_names     = ["container-subnet"]
  subnet_prefixes  = ["10.0.1.0/24"]
  
  # Add delegation for container instances on the first subnet
  delegations = [
    {
      name = "container-instance-delegation"
      service_delegation = {
        name = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  ]
  
  tags = merge(local.config.locals.common_tags, {
    Component = "VirtualNetwork"
  })
}