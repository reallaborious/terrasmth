run "basic_container_registry_test" {
  command = plan

  variables {
    name                = "testacr001basic"
    resource_group_name = "test-rg"
    location            = "East US"
    sku                 = "Basic"
    
    tags = {
      Environment = "Test"
      Purpose     = "BasicACR"
    }
  }

  assert {
    condition     = azurerm_container_registry.acr.name == "testacr001basic"
    error_message = "Container Registry name should match the provided name"
  }

  assert {
    condition     = azurerm_container_registry.acr.sku == "Basic"
    error_message = "SKU should be Basic"
  }

  assert {
    condition     = azurerm_container_registry.acr.admin_enabled == false
    error_message = "Admin should be disabled by default"
  }

  assert {
    condition     = azurerm_container_registry.acr.public_network_access_enabled == true
    error_message = "Public network access should be enabled by default"
  }

  assert {
    condition     = azurerm_container_registry.acr.tags["Environment"] == "Test"
    error_message = "Environment tag should be set correctly"
  }
}

run "standard_container_registry_test" {
  command = plan

  variables {
    name                = "testacr002standard"
    resource_group_name = "test-rg"
    location            = "West Europe"
    sku                 = "Standard"
    admin_enabled       = true
    
    tags = {
      Environment = "Development"
      Purpose     = "StandardACR"
    }
  }

  assert {
    condition     = azurerm_container_registry.acr.name == "testacr002standard"
    error_message = "Container Registry name should match the provided name"
  }

  assert {
    condition     = azurerm_container_registry.acr.sku == "Standard"
    error_message = "SKU should be Standard"
  }

  assert {
    condition     = azurerm_container_registry.acr.admin_enabled == true
    error_message = "Admin should be enabled when specified"
  }

  assert {
    condition     = azurerm_container_registry.acr.tags["Purpose"] == "StandardACR"
    error_message = "Purpose tag should be set correctly"
  }
}

run "premium_container_registry_test" {
  command = plan

  variables {
    name                = "testacr003premium"
    resource_group_name = "test-rg"
    location            = "East US"
    sku                 = "Premium"
    admin_enabled       = true
    
    georeplications = [
      {
        location                  = "West US"
        zone_redundancy_enabled   = true
        regional_endpoint_enabled = true
        tags = {
          Region = "West"
        }
      }
    ]
    
    network_rule_set = {
      default_action = "Deny"
      ip_rule = [
        {
          action   = "Allow"
          ip_range = "10.0.0.0/8"
        }
      ]
    }
    
    retention_policy = {
      days    = 14
      enabled = true
    }
    
    trust_policy = {
      enabled = true
    }
    
    identity = {
      type = "SystemAssigned"
    }
    
    tags = {
      Environment = "Production"
      Purpose     = "PremiumACR"
      Tier        = "Premium"
    }
  }

  assert {
    condition     = azurerm_container_registry.acr.name == "testacr003premium"
    error_message = "Container Registry name should match the provided name"
  }

  assert {
    condition     = azurerm_container_registry.acr.sku == "Premium"
    error_message = "SKU should be Premium"
  }

  assert {
    condition     = azurerm_container_registry.acr.admin_enabled == true
    error_message = "Admin should be enabled when specified"
  }

  assert {
    condition     = length(azurerm_container_registry.acr.georeplications) == 1
    error_message = "Should have one geo-replication configured"
  }

  assert {
    condition     = azurerm_container_registry.acr.georeplications[0].location == "westus"
    error_message = "Geo-replication location should be westus (normalized by Azure)"
  }

  assert {
    condition     = azurerm_container_registry.acr.network_rule_set[0].default_action == "Deny"
    error_message = "Network rule default action should be Deny"
  }

  assert {
    condition     = azurerm_container_registry.acr.retention_policy[0].enabled == true
    error_message = "Retention policy should be enabled"
  }

  assert {
    condition     = azurerm_container_registry.acr.retention_policy[0].days == 14
    error_message = "Retention policy days should be 14"
  }

  assert {
    condition     = azurerm_container_registry.acr.trust_policy[0].enabled == true
    error_message = "Trust policy should be enabled"
  }

  assert {
    condition     = azurerm_container_registry.acr.identity[0].type == "SystemAssigned"
    error_message = "Identity type should be SystemAssigned"
  }

  assert {
    condition     = azurerm_container_registry.acr.tags["Tier"] == "Premium"
    error_message = "Tier tag should be set correctly"
  }
}

run "container_registry_name_validation_test" {
  command = plan

  variables {
    name                = "invalid-name-with-hyphens"
    resource_group_name = "test-rg"
    location            = "East US"
    sku                 = "Basic"
  }

  expect_failures = [
    var.name
  ]
}

run "container_registry_sku_validation_test" {
  command = plan

  variables {
    name                = "testacr004validation"
    resource_group_name = "test-rg"
    location            = "East US"
    sku                 = "InvalidSKU"
  }

  expect_failures = [
    var.sku
  ]
}