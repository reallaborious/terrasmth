# https://www.terraform.io/docs/providers/azurerm/index.html
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}
provider "azurerm" {
  skip_provider_registration = true
  features {
    storage {
      prevent_deletion_if_contains_resources = true
    }
  }
}