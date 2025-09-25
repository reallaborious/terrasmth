include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "rg" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "mock-rg"
    location           = "eastus"
  }
}



terraform {
  source = "../../../terraform/elementary_modules/azure/public_ip"
}

inputs = {
  public_ip_name      = "ollama-vm-pip"
  resource_group_name = dependency.rg.outputs.resource_group_name
  location           = dependency.rg.outputs.location
  allocation_method  = "Static"
  sku               = "Standard"
  
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "public-ip"
  }
}