# Provider for testing - uses environment variables or CLI authentication
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  
  # Use environment variable ARM_SUBSCRIPTION_ID or Azure CLI authentication
  # Run: export ARM_SUBSCRIPTION_ID="your-sub-id" && terraform test
  # Or:  ARM_SUBSCRIPTION_ID="your-sub-id" terraform test
}sting with actual Azure authentication
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  
  # Use environment variable ARM_SUBSCRIPTION_ID or Azure CLI authentication
  # Run: export ARM_SUBSCRIPTION_ID="your-sub-id" && terraform test
  # Or:  ARM_SUBSCRIPTION_ID="your-sub-id" terraform test
}