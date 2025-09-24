resource "azurerm_subnet_network_security_group_association" "subnet" {
  count = var.subnet_id != null ? 1 : 0
  
  subnet_id                 = var.subnet_id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_network_interface_security_group_association" "network_interface" {
  count = var.network_interface_id != null ? 1 : 0
  
  network_interface_id      = var.network_interface_id
  network_security_group_id = var.network_security_group_id
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}