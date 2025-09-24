# Azure Resource Group Terraform Module

This module creates an Azure Resource Group with configurable timeouts and validation.

## Usage

```hcl
module "resource_group" {
  source = "./terraform/elementary_modules/azure/resource_group"
  
  rg_name         = "my-resource-group"
  location        = "West Europe"
  subscription_id = "11111111-1111-1111-1111-111111111111"
}
```

## Requirements

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| rg_name | Azure resource group name | `string` | n/a | yes |
| location | Azure resource group location | `string` | n/a | yes |
| subscription_id | Azure subscription ID where the resource group should be created | `string` | n/a | yes |
| timeout_create | Timeout for create operations | `string` | `"30m"` | no |
| timeout_update | Timeout for update operations | `string` | `"30m"` | no |
| timeout_delete | Timeout for delete operations | `string` | `"30m"` | no |
| timeout_read | Timeout for read operations | `string` | `"5m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the resource group |
| resource_group_name | Resource group name |
| location | Resource group location |

## Validation

- The `subscription_id` must be a valid UUID format (36 characters, hex + dashes)

## Examples

### Basic Resource Group

```hcl
module "basic_rg" {
  source = "./terraform/elementary_modules/azure/resource_group"
  
  rg_name         = "production-rg"
  location        = "West Europe"
  subscription_id = "11111111-1111-1111-1111-111111111111"
}
```

### Resource Group with Custom Timeouts

```hcl
module "custom_timeout_rg" {
  source = "./terraform/elementary_modules/azure/resource_group"
  
  rg_name         = "development-rg"
  location        = "East US"
  subscription_id = "11111111-1111-1111-1111-111111111111"
  
  timeout_create = "60m"
  timeout_delete = "60m"
}
```