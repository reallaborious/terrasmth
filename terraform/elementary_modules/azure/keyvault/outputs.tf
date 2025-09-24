// outputs.tf
output "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  value       = azurerm_key_vault.this.id
}

output "key_vault_dns_name" {
  description = "The DNS name of the Azure Key Vault."
  value       = azurerm_key_vault.this.vault_uri
}