# Azure Container Registry Module

This module creates an Azure Container Registry with configurable options for geo-replication, network rules, retention policies, and encryption.

## Features

- Support for Basic, Standard, and Premium SKUs
- Optional admin user configuration
- Geo-replication support for Premium SKUs
- Network access rules and firewall configuration
- Retention policy for untagged manifests
- Content trust policy support
- Managed identity integration
- Customer-managed encryption support
- Comprehensive validation rules

## Usage

### Basic Configuration

```hcl
module "container_registry" {
  source = "../../terraform/elementary_modules/azure/container_registry"
  
  name                = "myregistry"
  resource_group_name = "my-resource-group"
  location           = "East US"
  sku                = "Basic"
  
  tags = {
    Environment = "Production"
    Owner       = "DevOps"
  }
}
```

### Advanced Configuration with Premium Features

```hcl
module "container_registry" {
  source = "../../terraform/elementary_modules/azure/container_registry"
  
  name                = "myregistrypremium"
  resource_group_name = "my-resource-group" 
  location           = "East US"
  sku                = "Premium"
  admin_enabled      = true
  
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
    days    = 30
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
    Owner       = "DevOps"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | 3.75.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 3.75.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Specifies the name of the Container Registry. Only Alphanumeric characters allowed. | `string` | n/a | yes |
| resource_group_name | The name of the resource group in which to create the Container Registry. | `string` | n/a | yes |
| location | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| sku | The SKU name of the container registry. Possible values are Basic, Standard and Premium. | `string` | `"Basic"` | no |
| admin_enabled | Specifies whether the admin user is enabled. | `bool` | `false` | no |
| public_network_access_enabled | Whether public network access is allowed for the container registry. | `bool` | `true` | no |
| georeplications | A list of geo-replications configuration blocks. | `list(object)` | `[]` | no |
| network_rule_set | A network_rule_set block to restrict access to the container registry. | `object` | `null` | no |
| retention_policy | A retention_policy block to configure retention policy for untagged manifests. | `object` | `null` | no |
| trust_policy | A trust_policy block to configure content trust for the container registry. | `object` | `null` | no |
| identity | An identity block to configure managed identity for the container registry. | `object` | `null` | no |
| encryption | An encryption block to configure encryption for the container registry. | `object` | `null` | no |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| timeout_create | Timeout for create operations | `string` | `"30m"` | no |
| timeout_update | Timeout for update operations | `string` | `"30m"` | no |
| timeout_delete | Timeout for delete operations | `string` | `"30m"` | no |
| timeout_read | Timeout for read operations | `string` | `"5m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Container Registry. |
| name | The name of the Container Registry. |
| login_server | The URL that can be used to log into the container registry. |
| admin_username | The Username associated with the Container Registry Admin account - if the admin account is enabled. |
| admin_password | The Password associated with the Container Registry Admin account - if the admin account is enabled. |
| identity | An identity block, which contains the Managed Service Identity information for this Container Registry. |

## Notes

- Container Registry names must be globally unique across Azure
- Geo-replication is only available for Premium SKU
- Network rules and advanced features require Standard or Premium SKU
- Admin credentials are sensitive and should be handled securely
- The registry name must be between 5 and 50 characters and contain only alphanumeric characters