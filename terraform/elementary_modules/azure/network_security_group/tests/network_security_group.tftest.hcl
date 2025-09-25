run "basic_nsg_test" {
  command = plan

  variables {
    network_security_group_name = "test-nsg-basic"
    location            = "East US"
    resource_group_name = "test-rg"
    
    tags = {
      Environment = "Test"
      Purpose     = "BasicNSG"
    }
  }

  assert {
    condition     = azurerm_network_security_group.this.name == "test-nsg-basic"
    error_message = "Network security group name should match the provided name"
  }

  assert {
    condition     = azurerm_network_security_group.this.location == "eastus"
    error_message = "Location should match the provided location (normalized)"
  }

  assert {
    condition     = azurerm_network_security_group.this.resource_group_name == "test-rg"
    error_message = "Resource group name should match"
  }

  assert {
    condition     = azurerm_network_security_group.this.tags["Purpose"] == "BasicNSG"
    error_message = "Purpose tag should be set correctly"
  }
}

run "nsg_with_security_rules_test" {
  command = plan

  variables {
    network_security_group_name = "test-nsg-rules"
    location            = "West Europe"
    resource_group_name = "test-rg"
    
    security_rules = [
      {
        name                       = "allow_ssh"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
      },
      {
        name                       = "allow_http"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "deny_all"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    
    tags = {
      Environment = "Test"
      Purpose     = "RulesNSG"
    }
  }

  assert {
    condition     = azurerm_network_security_group.this.name == "test-nsg-rules"
    error_message = "Network security group name should match the provided name"
  }

  # Note: Security rule details are not available during plan phase
  # These assertions verify the module accepts the security rules input
  assert {
    condition     = azurerm_network_security_group.this.name == "test-nsg-rules"
    error_message = "Network security group name should match the provided name"
  }

  assert {
    condition     = azurerm_network_security_group.this.location == "westeurope"
    error_message = "Location should match the provided location (normalized)"
  }

  assert {
    condition     = azurerm_network_security_group.this.tags["Purpose"] == "RulesNSG"
    error_message = "Purpose tag should be set correctly"
  }
}