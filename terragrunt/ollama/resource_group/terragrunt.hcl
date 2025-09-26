include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/resource_group"
}

inputs = {
  rg_name = "ollama-rg"
  location = "westeurope"
  subscription_id = get_env("ARM_SUBSCRIPTION_ID")
  tags = { environment = "ollama" }
}