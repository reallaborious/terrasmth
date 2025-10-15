include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

locals {
  root  = read_terragrunt_config(find_in_parent_folders("variables_ollama.hcl"))
  cloud = try(local.root.locals.cloud, get_env("CLOUD", get_env("AWS_REGION", "") != "" ? "aws" : "azure"))
}

dependency "rg" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "mock-rg"
    location           = "eastus"
  }
}

dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    subnet_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet/subnets/mock-subnet"]
  }
}

dependency "public_ip" {
  config_path = "../public_ip"
  
  mock_outputs = {
    public_ip_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/publicIPAddresses/mock-pip"
  }
}

terraform {
  source = "../../../terraform/elementary_modules/cloud/network_interface"
  include_in_copy = [
    "../../../terraform/elementary_modules/aws",
    "../../../terraform/elementary_modules/azure"
  ]
}

inputs = {
  cloud            = local.cloud
  location         = dependency.rg.outputs.location
  rg_name          = dependency.rg.outputs.resource_group_name
  subnet_id        = dependency.network.outputs.subnet_ids[0]
  public_ip_id     = dependency.public_ip.outputs.public_ip_id
  security_group_id = dependency.nsg.outputs.network_security_group_id
  
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "network-interface"
  }
}