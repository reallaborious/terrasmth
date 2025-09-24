resource "azurerm_network_security_group" "this" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "rules" {
  for_each = { for rule in var.security_rules : rule.name => rule }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  source_port_ranges          = each.value.source_port_ranges
  destination_port_range      = each.value.destination_port_range
  destination_port_ranges     = each.value.destination_port_ranges
  source_address_prefix       = each.value.source_address_prefix
  source_address_prefixes     = each.value.source_address_prefixes
  destination_address_prefix  = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name

  depends_on = [azurerm_network_security_group.this]
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}