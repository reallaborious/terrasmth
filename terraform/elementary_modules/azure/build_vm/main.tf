# Build VM Module for Docker Image Building
# This module creates a specialized VM for building Docker images and pushing to ACR

# Generate SSH key pair
resource "tls_private_key" "build_vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key locally for access
resource "local_file" "private_key" {
  content         = tls_private_key.build_vm_ssh.private_key_pem
  filename        = "${path.module}/build-vm-key.pem"
  file_permission = "0600"
}

# Network interface for build VM
resource "azurerm_network_interface" "build_vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }

  tags = var.tags
}

# Managed Identity for ACR access
resource "azurerm_user_assigned_identity" "build_vm_identity" {
  name                = "${var.vm_name}-identity"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Get current client config for subscription ID
data "azurerm_client_config" "current" {}

# Assign ACR Push role to managed identity
resource "azurerm_role_assignment" "acr_push" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ContainerRegistry/registries/${var.acr_name}"
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.build_vm_identity.principal_id
}

# Template cloud-init with variables
locals {
  cloud_init_content = templatefile("${path.module}/cloud-init-build.yml", {
    ssh_public_key = tls_private_key.build_vm_ssh.public_key_openssh
    acr_name       = var.acr_name
  })
}

# Linux Virtual Machine for building
resource "azurerm_linux_virtual_machine" "build_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  
  # Disable password authentication
  disable_password_authentication = true
  
  # Network configuration
  network_interface_ids = [azurerm_network_interface.build_vm_nic.id]
  
  # SSH key configuration
  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.build_vm_ssh.public_key_openssh
  }
  
  # Assign managed identity
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.build_vm_identity.id]
  }
  
  # OS disk configuration
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }
  
  # Ubuntu 22.04 LTS
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  
  # Cloud-init configuration
  custom_data = base64encode(local.cloud_init_content)
  
  tags = var.tags
  
  depends_on = [
    azurerm_role_assignment.acr_push
  ]
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}