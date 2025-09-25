run "single_ip_configuration_test" {
  command = plan

  variables {
    network_interface_name = "test-nic-single"
    location            = "East US"
    resource_group_name = "test-rg"
    
    ip_configurations = [
      {
        name                          = "primary"
        subnet_id                     = "/subscriptions/test/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = null
        primary                       = true
      }
    ]
    
    tags = {
      Environment = "Test"
      Purpose     = "SingleIP"
    }
  }

  assert {
    condition     = azurerm_network_interface.this.name == "test-nic-single"
    error_message = "Network interface name should match the provided name"
  }

  assert {
    condition = length(azurerm_network_interface.this.ip_configuration) == 1
    error_message = "Should have exactly 1 IP configuration"
  }

  assert {
    condition     = azurerm_network_interface.this.ip_configuration[0].name == "primary"
    error_message = "IP configuration name should be 'primary'"
  }

  assert {
    condition     = azurerm_network_interface.this.ip_configuration[0].private_ip_address_allocation == "Dynamic"
    error_message = "Private IP allocation should be Dynamic"
  }

  assert {
    condition     = azurerm_network_interface.this.ip_configuration[0].primary == true
    error_message = "First IP configuration should be primary"
  }

  assert {
    condition     = azurerm_network_interface.this.tags["Purpose"] == "SingleIP"
    error_message = "Purpose tag should be set correctly"
  }
}

run "multiple_ip_configuration_test" {
  command = plan

  variables {
    network_interface_name = "test-nic-multi"
    location            = "West Europe"
    resource_group_name = "test-rg"
    
    ip_configurations = [
      {
        name                          = "primary"
        subnet_id                     = "/subscriptions/test/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.10"
        public_ip_address_id          = "/subscriptions/test/resourceGroups/test-rg/providers/Microsoft.Network/publicIPAddresses/test-pip"
        primary                       = true
      },
      {
        name                          = "secondary"
        subnet_id                     = "/subscriptions/test/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = null
        primary                       = false
      }
    ]
    
    enable_accelerated_networking = true
    
    tags = {
      Environment = "Test"
      Purpose     = "MultiIP"
    }
  }

  assert {
    condition     = azurerm_network_interface.this.name == "test-nic-multi"
    error_message = "Network interface name should match the provided name"
  }

  assert {
    condition = length(azurerm_network_interface.this.ip_configuration) == 2
    error_message = "Should have exactly 2 IP configurations"
  }

  assert {
    condition     = azurerm_network_interface.this.ip_configuration[0].primary == true
    error_message = "First IP configuration should be primary"
  }

  assert {
    condition     = azurerm_network_interface.this.ip_configuration[1].primary == false
    error_message = "Second IP configuration should not be primary"
  }

  assert {
    condition     = azurerm_network_interface.this.accelerated_networking_enabled == true
    error_message = "Accelerated networking should be enabled"
  }

  assert {
    condition     = azurerm_network_interface.this.ip_configuration[0].private_ip_address == "10.0.1.10"
    error_message = "Static IP address should match configured value"
  }

  assert {
    condition     = azurerm_network_interface.this.tags["Purpose"] == "MultiIP"
    error_message = "Purpose tag should be set correctly"
  }
}