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



terraform {
  source = "../../../terraform/elementary_modules/cloud/public_ip"
  include_in_copy = [
    "../../../terraform/elementary_modules/aws",
    "../../../terraform/elementary_modules/azure"
  ]
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