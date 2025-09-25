output "network_interface_id" {
  description = "The ID of the network interface"
  value       = azurerm_network_interface.this.id
}

output "private_ip_address" {
  description = "The first private IP address of the network interface"
  value       = azurerm_network_interface.this.private_ip_address
}

output "private_ip_addresses" {
  description = "The private IP addresses of the network interface"
  value       = azurerm_network_interface.this.private_ip_addresses
}

output "mac_address" {
  description = "The media access control (MAC) address of the network interface"
  value       = azurerm_network_interface.this.mac_address
}