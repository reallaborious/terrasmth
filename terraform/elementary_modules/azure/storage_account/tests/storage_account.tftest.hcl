run "basic_storage_account_test" {
  command = plan

  variables {
    name                = "teststorage001"
    resource_group_name = "test-rg"
    location            = "East US"
    
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind            = "StorageV2"
    
    tags = {
      Environment = "Test"
      Purpose     = "BasicStorage"
    }
  }

  assert {
    condition     = azurerm_storage_account.this.name == "teststorage001"
    error_message = "Storage account name should match the provided name"
  }

  assert {
    condition     = azurerm_storage_account.this.account_tier == "Standard"
    error_message = "Account tier should be Standard"
  }

  assert {
    condition     = azurerm_storage_account.this.account_replication_type == "LRS"
    error_message = "Replication type should be LRS"
  }

  assert {
    condition     = azurerm_storage_account.this.tags["Environment"] == "Test"
    error_message = "Environment tag should be set correctly"
  }
}

run "premium_storage_account_test" {
  command = plan

  variables {
    name                = "premiumstorage002"
    resource_group_name = "test-rg"
    location            = "West Europe"
    
    account_tier             = "Premium"
    account_replication_type = "LRS"
    account_kind            = "BlockBlobStorage"
    
    min_tls_version                = "TLS1_2"
    enable_https_traffic_only      = true
    public_network_access_enabled  = false
    
    tags = {
      Environment = "Production"
      Purpose     = "PremiumStorage"
    }
  }

  assert {
    condition     = azurerm_storage_account.this.account_tier == "Premium"
    error_message = "Account tier should be Premium"
  }

  assert {
    condition     = azurerm_storage_account.this.account_kind == "BlockBlobStorage"
    error_message = "Account kind should be BlockBlobStorage for Premium"
  }

  assert {
    condition     = azurerm_storage_account.this.public_network_access_enabled == false
    error_message = "Public network access should be disabled"
  }
}

run "storage_account_with_blob_properties_test" {
  command = plan

  variables {
    name                = "blobstorage003"
    resource_group_name = "test-rg"
    location            = "North Europe"
    
    blob_properties = {
      versioning_enabled       = true
      change_feed_enabled      = false
      last_access_time_enabled = true
      delete_retention_policy = {
        days = 14
      }
    }
    
    tags = {
      Environment = "Development"
      Purpose     = "BlobStorage"
    }
  }

  assert {
    condition     = azurerm_storage_account.this.blob_properties[0].versioning_enabled == true
    error_message = "Blob versioning should be enabled"
  }
}

run "storage_account_name_validation_test" {
  command = plan
  expect_failures = [var.name]

  variables {
    name                = "Invalid-Storage-Name!"
    resource_group_name = "test-rg"
    location            = "East US"
  }
}

run "storage_account_tier_validation_test" {
  command = plan
  expect_failures = [var.account_tier]

  variables {
    name                = "validname123"
    resource_group_name = "test-rg"
    location            = "East US"
    account_tier        = "InvalidTier"
  }
}