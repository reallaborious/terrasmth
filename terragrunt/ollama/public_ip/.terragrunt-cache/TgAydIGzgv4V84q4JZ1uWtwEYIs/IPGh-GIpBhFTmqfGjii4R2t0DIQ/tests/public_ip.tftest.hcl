run "static_public_ip_test" {
  command = plan

  variables {
    public_ip_name      = "test-static-pip"
    resource_group_name = "test-rg"
    location            = "East US"
    allocation_method   = "Static"
    sku                 = "Standard"
    
    tags = {
      Environment = "Test"
      Purpose     = "StaticIP"
    }
  }

  assert {
    condition     = azurerm_public_ip.this.name == "test-static-pip"
    error_message = "Public IP name should match the provided name"
  }

  assert {
    condition     = azurerm_public_ip.this.allocation_method == "Static"
    error_message = "Allocation method should be Static"
  }

  assert {
    condition     = azurerm_public_ip.this.sku == "Standard"
    error_message = "SKU should be Standard for static allocation"
  }

  assert {
    condition     = azurerm_public_ip.this.sku == "Standard"
    error_message = "SKU should be Standard for static allocation"
  }

  assert {
    condition     = azurerm_public_ip.this.tags["Environment"] == "Test"
    error_message = "Environment tag should be set correctly"
  }
}

run "dynamic_public_ip_test" {
  command = plan

  variables {
    public_ip_name      = "test-dynamic-pip"
    resource_group_name = "test-rg"
    location            = "West Europe"
    allocation_method   = "Dynamic"
    sku                 = "Basic"
    
    tags = {
      Environment = "Development"
      Purpose     = "DynamicIP"
    }
  }

  assert {
    condition     = azurerm_public_ip.this.name == "test-dynamic-pip"
    error_message = "Public IP name should match the provided name"
  }

  assert {
    condition     = azurerm_public_ip.this.allocation_method == "Dynamic"
    error_message = "Allocation method should be Dynamic"
  }

  assert {
    condition     = azurerm_public_ip.this.sku == "Basic"
    error_message = "SKU should be Basic for dynamic allocation"
  }

  assert {
    condition     = azurerm_public_ip.this.sku == "Basic"
    error_message = "SKU should be Basic for dynamic allocation"
  }

  assert {
    condition     = azurerm_public_ip.this.tags["Purpose"] == "DynamicIP"
    error_message = "Purpose tag should be set correctly"
  }
}