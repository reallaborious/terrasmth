output "id" {
  description = "ID of the Linux virtual machine"
  value       = azurerm_linux_virtual_machine.this.id
}

output "name" {
  description = "Name of the Linux virtual machine"
  value       = azurerm_linux_virtual_machine.this.name
}

output "private_ip_address" {
  description = "Primary private IP address of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.private_ip_address
}

output "private_ip_addresses" {
  description = "List of all private IP addresses of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.private_ip_addresses
}

output "public_ip_address" {
  description = "Primary public IP address of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.public_ip_address
}

output "public_ip_addresses" {
  description = "List of all public IP addresses of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.public_ip_addresses
}

output "virtual_machine_id" {
  description = "Unique identifier of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.virtual_machine_id
}

output "identity" {
  description = "Identity block of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.identity
}