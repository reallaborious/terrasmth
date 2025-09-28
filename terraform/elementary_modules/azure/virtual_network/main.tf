resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
  
  # Add delegation for container instances if specified
  dynamic "delegation" {
    for_each = var.delegations != null ? (try(var.delegations[count.index], null) != null ? [var.delegations[count.index]] : []) : []
    content {
      name = delegation.value.name
      
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

provider "azurerm" {
  features {}
}