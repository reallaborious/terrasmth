run "nsg_subnet_association_test" {
  command = plan

  variables {
    subnet_id                = "/subscriptions/test-subscription/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
    network_security_group_id = "/subscriptions/test-subscription/resourceGroups/test-rg/providers/Microsoft.Network/networkSecurityGroups/test-nsg"
  }

  assert {
    condition     = azurerm_subnet_network_security_group_association.this.subnet_id == "/subscriptions/test-subscription/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
    error_message = "Subnet ID should match the provided value"
  }

  assert {
    condition     = azurerm_subnet_network_security_group_association.this.network_security_group_id == "/subscriptions/test-subscription/resourceGroups/test-rg/providers/Microsoft.Network/networkSecurityGroups/test-nsg"
    error_message = "Network security group ID should match the provided value"
  }
}

run "nsg_subnet_association_validation_test" {
  command = plan

  variables {
    subnet_id                = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/prod-rg/providers/Microsoft.Network/virtualNetworks/prod-vnet/subnets/web-subnet"
    network_security_group_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/prod-rg/providers/Microsoft.Network/networkSecurityGroups/web-nsg"
  }

  assert {
    condition = length(split("/", azurerm_subnet_network_security_group_association.this.subnet_id)) == 11
    error_message = "Subnet ID should have the correct Azure resource ID format"
  }

  assert {
    condition = length(split("/", azurerm_subnet_network_security_group_association.this.network_security_group_id)) == 9
    error_message = "Network security group ID should have the correct Azure resource ID format"
  }

  assert {
    condition = contains(split("/", azurerm_subnet_network_security_group_association.this.subnet_id), "subnets")
    error_message = "Subnet ID should contain 'subnets' in the path"
  }

  assert {
    condition = contains(split("/", azurerm_subnet_network_security_group_association.this.network_security_group_id), "networkSecurityGroups")
    error_message = "Network security group ID should contain 'networkSecurityGroups' in the path"
  }
}