output "id" {
  value       = azurerm_container_registry.acr.id
  description = "The ID of the Container Registry."
}

output "name" {
  value       = azurerm_container_registry.acr.name
  description = "The name of the Container Registry."
}

output "login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The URL that can be used to log into the container registry."
}

output "admin_username" {
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_username : null
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled."
  sensitive   = true
}

output "admin_password" {
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_password : null
  description = "The Password associated with the Container Registry Admin account - if the admin account is enabled."
  sensitive   = true
}

output "identity" {
  value = var.identity != null ? {
    principal_id = azurerm_container_registry.acr.identity[0].principal_id
    tenant_id    = azurerm_container_registry.acr.identity[0].tenant_id
    type         = azurerm_container_registry.acr.identity[0].type
    identity_ids = azurerm_container_registry.acr.identity[0].identity_ids
  } : null
  description = "An identity block, which contains the Managed Service Identity information for this Container Registry."
}

# ACR tasks outputs removed - will be handled separately