output "public_ip_id" {
  description = "The ID of the public IP address"
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "The IP address value that was allocated"
  value       = azurerm_public_ip.this.ip_address
}

output "public_ip_fqdn" {
  description = "The fully qualified domain name of the A DNS record associated with the public IP"
  value       = azurerm_public_ip.this.fqdn
}