include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "rg" {
  config_path = "../resource_group"
}

terraform {
  source = "../../../terraform/elementary_modules/azure/virtual_network"
}

inputs = {
  vnet_name       = "ollama-vnet"
  location        = "westeurope"
  rg_name         = dependency.rg.outputs.resource_group_name
  address_space   = ["10.0.0.0/16"]
  subnet_names    = ["ollama-subnet"]
  subnet_prefixes = ["10.0.1.0/24"]
}