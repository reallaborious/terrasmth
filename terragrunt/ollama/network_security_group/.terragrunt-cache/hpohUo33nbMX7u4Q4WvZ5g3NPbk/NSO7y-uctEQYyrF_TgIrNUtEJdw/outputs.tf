output "network_security_group_id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.this.id
}

output "network_security_group_name" {
  description = "The name of the network security group"
  value       = azurerm_network_security_group.this.name
}

output "security_rule_ids" {
  description = "Map of security rule names to their IDs"
  value       = { for name, rule in azurerm_network_security_rule.rules : name => rule.id }
}