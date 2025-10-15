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
  source = "../../../terraform/elementary_modules/cloud/network"
  include_in_copy = [
    "../../../terraform/elementary_modules/aws",
    "../../../terraform/elementary_modules/azure"
  ]
}

inputs = {
  cloud           = local.cloud
  location        = dependency.rg.outputs.location
  rg_name         = dependency.rg.outputs.resource_group_name
  address_space   = ["10.0.0.0/16"]
  subnet_names    = ["ollama-subnet"]
  subnet_prefixes = ["10.0.1.0/24"]
  
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "network"
  }
}