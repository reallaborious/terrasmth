include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/resource_group"
}

inputs = {
  rg_name = "ollama-rg"
  location = get_env("TF_LOCATION", "westus")
  subscription_id = get_env("ARM_SUBSCRIPTION_ID", "24246c45-86af-407e-993c-1883f8735933")
  tags = { environment = "ollama" }
}
