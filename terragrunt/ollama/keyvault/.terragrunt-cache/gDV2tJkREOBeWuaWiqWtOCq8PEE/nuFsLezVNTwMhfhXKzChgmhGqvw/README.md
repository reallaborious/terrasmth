# Azure Key Vault Terraform Module

This module creates an Azure Key Vault resource. It allows you to manage secrets, keys, and certificates securely.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "keyvault" {
  source              = "./terraform/elementary_modules/azure/keyvault"
  key_vault_name     = "your-keyvault-name"
  resource_group_name = "your-resource-group-name"
  location           = "your-location"
}
```

## Inputs

| Name                  | Description                              | Type   | Default | Required |
|-----------------------|------------------------------------------|--------|---------|:--------:|
| key_vault_name        | The name of the Key Vault.              | string | n/a     |   yes    |
| resource_group_name    | The name of the resource group.         | string | n/a     |   yes    |
| location              | The location where the Key Vault will be created. | string | n/a     |   yes    |
| sku_name              | The SKU name for the Key Vault.         | string | "standard" | no     |

## Outputs

| Name                  | Description                              |
|-----------------------|------------------------------------------|
| key_vault_id          | The ID of the Key Vault.                 |
| key_vault_dns_name    | The DNS name of the Key Vault.           |

## Example

```hcl
module "keyvault" {
  source              = "./terraform/elementary_modules/azure/keyvault"
  key_vault_name     = "example-keyvault"
  resource_group_name = "example-resource-group"
  location           = "East US"
}
```

## Requirements

- Terraform 0.12 or later
- Azure Provider

## Author

This module is maintained by [Your Name].