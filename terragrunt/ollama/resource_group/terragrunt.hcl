include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/resource_group"
}

inputs = {
  rg_name = "ollama-rg"
  location = local.location
  subscription_id = local.subscription_id
  tags = { environment = "ollama" }
}
