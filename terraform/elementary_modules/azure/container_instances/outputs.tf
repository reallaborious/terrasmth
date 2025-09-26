output "id" {
  value       = azurerm_container_group.aci.id
  description = "The ID of the Container Group."
}

output "name" {
  value       = azurerm_container_group.aci.name
  description = "The name of the Container Group."
}

output "ip_address" {
  value       = azurerm_container_group.aci.ip_address
  description = "The IP address allocated to the container group."
}

output "fqdn" {
  value       = azurerm_container_group.aci.fqdn
  description = "The FQDN of the container group derived from dns_name_label."
}

output "identity" {
  value = var.identity != null ? {
    principal_id = azurerm_container_group.aci.identity[0].principal_id
    tenant_id    = azurerm_container_group.aci.identity[0].tenant_id
    type         = azurerm_container_group.aci.identity[0].type
    identity_ids = azurerm_container_group.aci.identity[0].identity_ids
  } : null
  description = "An identity block, which contains the Managed Service Identity information for this Container Group."
}