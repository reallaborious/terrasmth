# Azure Virtual Network Terraform Module

This module creates an Azure Virtual Network with one or more subnets.

## Usage

```hcl
module "virtual_network" {
  source = "./terraform/elementary_modules/azure/virtual_network"
  
  vnet_name       = "my-vnet"
  location        = "West Europe"
  rg_name         = "my-resource-group"
  address_space   = ["10.0.0.0/16"]
  subnet_names    = ["subnet1", "subnet2"]
  subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]
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

## Resources

| Name | Type |
|------|------|
| azurerm_virtual_network.vnet | resource |
| azurerm_subnet.subnet | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vnet_name | The name of the virtual network | `string` | n/a | yes |
| location | The Azure region where the virtual network will be located | `string` | n/a | yes |
| rg_name | The name of the resource group where the virtual network will be created | `string` | n/a | yes |
| address_space | The address space that is used by the virtual network | `list(string)` | n/a | yes |
| subnet_names | A list of subnet names | `list(string)` | n/a | yes |
| subnet_prefixes | A list of subnet address prefixes | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | The ID of the virtual network |
| subnet_ids | The IDs of the subnets |
| subnet_names | The names of the subnets |

## Examples

### Basic Virtual Network with Single Subnet

```hcl
module "basic_vnet" {
  source = "./terraform/elementary_modules/azure/virtual_network"
  
  vnet_name       = "production-vnet"
  location        = "West Europe"
  rg_name         = "production-rg"
  address_space   = ["10.0.0.0/16"]
  subnet_names    = ["web-subnet"]
  subnet_prefixes = ["10.0.1.0/24"]
}
```

### Virtual Network with Multiple Subnets

```hcl
module "multi_subnet_vnet" {
  source = "./terraform/elementary_modules/azure/virtual_network"
  
  vnet_name       = "enterprise-vnet"
  location        = "East US"
  rg_name         = "enterprise-rg"
  address_space   = ["10.0.0.0/16"]
  subnet_names    = ["web-subnet", "app-subnet", "db-subnet"]
  subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
```

## Important Notes

- The number of `subnet_names` must match the number of `subnet_prefixes`
- Each subnet prefix must be within the virtual network's address space
- Subnet names must be unique within the virtual network