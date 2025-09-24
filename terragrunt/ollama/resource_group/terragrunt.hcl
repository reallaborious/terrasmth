include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/resource_group"
}

inputs = {
  resource_group_name = "ollama-rg"
  location            = "westeurope"
  tags = { environment = "ollama" }
}