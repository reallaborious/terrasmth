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
  source = "../../../terraform/elementary_modules/cloud/public_ip"
}

inputs = {
  cloud     = local.cloud
  rg_name   = dependency.rg.outputs.resource_group_name
  location  = dependency.rg.outputs.location
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "public-ip"
  }
}