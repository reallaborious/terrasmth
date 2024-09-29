# https://www.terraform.io/docs/providers/azurerm/index.html
terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
  }

}
provider "azurerm" {
  subscription_id = var.subscription_id
  alias           = "vnetconnectivity"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
