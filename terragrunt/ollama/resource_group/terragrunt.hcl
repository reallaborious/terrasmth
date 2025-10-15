include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/resource_group"
}

inputs = {
  rg_name = "ollama-rg"
  location = get_env("TF_LOCATION", "westus")
  # During validate, allow a fallback UUID to satisfy validation; ignored if not applying
  subscription_id = get_env("ARM_SUBSCRIPTION_ID", "00000000-0000-0000-0000-000000000000")
  tags = { environment = "ollama" }
}
