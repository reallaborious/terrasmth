output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = [for s in azurerm_subnet.subnet : s.id]
}

output "subnet_names" {
  description = "The names of the subnets."
  value       = [for s in azurerm_subnet.subnet : s.name]
}