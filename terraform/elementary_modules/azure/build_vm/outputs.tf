# Output values for the build VM module

output "vm_id" {
  description = "ID of the build virtual machine"
  value       = azurerm_linux_virtual_machine.build_vm.id
}

output "vm_name" {
  description = "Name of the build virtual machine"
  value       = azurerm_linux_virtual_machine.build_vm.name
}

output "public_ip_address" {
  description = "Public IP address of the build VM"
  value       = azurerm_linux_virtual_machine.build_vm.public_ip_address
}

output "private_ip_address" {
  description = "Private IP address of the build VM"
  value       = azurerm_linux_virtual_machine.build_vm.private_ip_address
}

output "ssh_private_key_pem" {
  description = "Private SSH key for accessing the build VM"
  value       = tls_private_key.build_vm_ssh.private_key_pem
  sensitive   = true
}

output "ssh_public_key" {
  description = "Public SSH key used for the build VM"
  value       = tls_private_key.build_vm_ssh.public_key_openssh
}

output "managed_identity_id" {
  description = "ID of the managed identity assigned to the build VM"
  value       = azurerm_user_assigned_identity.build_vm_identity.id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the managed identity"
  value       = azurerm_user_assigned_identity.build_vm_identity.principal_id
}