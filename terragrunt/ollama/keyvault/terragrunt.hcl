include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "rg" {
  config_path = "../resource_group"
}

terraform {
  source = "../../../terraform/elementary_modules/azure/keyvault"
}

inputs = {
  key_vault_name             = "ollama-kv"
  location                   = "westeurope"
  resource_group_name        = dependency.rg.outputs.resource_group_name
  sku_name                   = "standard"
  tenant_id                  = local.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags = { environment = "ollama" }
}