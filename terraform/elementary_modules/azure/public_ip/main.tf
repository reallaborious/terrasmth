resource "azurerm_public_ip" "this" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.sku
  
  domain_name_label   = var.domain_name_label
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  
  tags = var.tags
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}