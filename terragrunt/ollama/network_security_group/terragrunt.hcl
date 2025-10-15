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
  source = "../../../terraform/elementary_modules/cloud/security"
}

inputs = {
  cloud    = local.cloud
  location = dependency.rg.outputs.location
  rg_name  = dependency.rg.outputs.resource_group_name
  vpc_id   = null
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "network-security-group"
  }
}