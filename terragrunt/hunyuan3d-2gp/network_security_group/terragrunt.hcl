include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/network_security_group"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

dependency "resource_group" {
  config_path = "../resource_group"
}

inputs = {
  network_security_group_name = "${local.config.locals.project_name}-nsg"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location           = local.config.locals.location
  subscription_id    = local.config.locals.subscription_id
  
  security_rules = [
    {
      name                       = "AllowHTTP"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = local.config.locals.api_port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowSSH"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  
  tags = merge(local.config.locals.common_tags, {
    Component = "NetworkSecurity"
  })
}