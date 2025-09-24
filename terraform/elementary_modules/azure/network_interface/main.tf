resource "azurerm_network_interface" "this" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
      primary                       = ip_configuration.value.primary
    }
  }

  dns_servers                   = var.dns_servers
  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding         = var.enable_ip_forwarding

  tags = var.tags
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}