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
  source = "../../../terraform/elementary_modules/azure/keyvault"
}

inputs = {
  key_vault_name             = "ollama-kv"
  location                   = dependency.rg.outputs.location
  resource_group_name        = dependency.rg.outputs.resource_group_name
  sku_name                   = "standard"
  # Use optional ARM_TENANT_ID during validate; allow null
  tenant_id                  = get_env("ARM_TENANT_ID", null)
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags = { environment = "ollama" }
}