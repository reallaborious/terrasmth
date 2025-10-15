# Linux Virtual Machine Module
# This module creates a Linux VM with configurable parameters and uses existing network interfaces

resource "azurerm_linux_virtual_machine" "this" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  
  # Disable password authentication when using SSH keys
  disable_password_authentication = var.disable_password_authentication

  # Network interfaces (created by network_interface module)
  network_interface_ids = var.network_interface_ids

  # Custom data for cloud-init
  custom_data = var.custom_data

  # SSH key configuration
  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key != null && trimspace(var.ssh_public_key) != "" ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.ssh_public_key
    }
  }

  # OS disk configuration
  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  # Source image configuration
  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  # Optional boot diagnostics
  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_storage_account_uri != null ? [1] : []
    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }

  # Tags
  tags = var.tags
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}