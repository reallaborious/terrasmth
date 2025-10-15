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
  source = local.cloud == "azure" ? "../../../terraform/elementary_modules/azure/network_interface" : "../../../terraform/elementary_modules/aws/eni"
}

inputs = local.cloud == "azure" ? {
  network_interface_name = "ollama-vm-nic"
  location               = dependency.rg.outputs.location
  resource_group_name    = dependency.rg.outputs.resource_group_name
  ip_configurations = [
    {
      name                          = "internal"
      subnet_id                     = dependency.network.outputs.subnet_ids[0]
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = dependency.public_ip.outputs.public_ip_id
    }
  ]
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "network-interface"
  }
} : {
  region                 = dependency.rg.outputs.location
  subnet_id              = dependency.network.outputs.subnet_ids[0]
  public_ip_allocation_id = dependency.public_ip.outputs.public_ip_id
  security_group_ids     = []
}