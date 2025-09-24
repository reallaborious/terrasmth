output "subnet_association_id" {
  description = "The ID of the subnet NSG association (if created)"
  value       = var.subnet_id != null ? azurerm_subnet_network_security_group_association.subnet[0].id : null
}

output "network_interface_association_id" {
  description = "The ID of the network interface NSG association (if created)"
  value       = var.network_interface_id != null ? azurerm_network_interface_security_group_association.network_interface[0].id : null
}

output "association_type" {
  description = "The type of association created ('subnet' or 'network_interface')"
  value       = var.subnet_id != null ? "subnet" : (var.network_interface_id != null ? "network_interface" : "none")
}