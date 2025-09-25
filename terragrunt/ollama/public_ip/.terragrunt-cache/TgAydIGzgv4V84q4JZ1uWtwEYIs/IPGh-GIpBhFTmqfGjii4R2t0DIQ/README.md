# Azure Public IP Terraform Module

This module creates an Azure Public IP address with configurable allocation method and SKU settings.

## Usage

```hcl
module "public_ip" {
  source = "./terraform/elementary_modules/azure/public_ip"
  
  public_ip_name      = "my-public-ip"
  resource_group_name = "my-resource-group"
  location            = "West Europe"
  allocation_method   = "Static"
  sku                 = "Standard"
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
| azurerm_public_ip.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| public_ip_name | The name of the public IP address | `string` | n/a | yes |
| resource_group_name | The name of the resource group where the public IP will be created | `string` | n/a | yes |
| location | The Azure region where the public IP will be located | `string` | n/a | yes |
| allocation_method | The allocation method for the public IP address ('Static' or 'Dynamic') | `string` | `"Static"` | no |
| sku | The SKU of the public IP address ('Basic' or 'Standard') | `string` | `"Standard"` | no |
| domain_name_label | Label for the Domain Name. Will be used to make up the FQDN | `string` | `null` | no |
| idle_timeout_in_minutes | Specifies the timeout for the TCP idle connection (4-30 minutes) | `number` | `4` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| public_ip_id | The ID of the public IP address |
| public_ip_address | The IP address value that was allocated |
| public_ip_fqdn | The fully qualified domain name of the A DNS record associated with the public IP |

## Examples

### Basic Static Public IP

```hcl
module "basic_public_ip" {
  source = "./terraform/elementary_modules/azure/public_ip"
  
  public_ip_name      = "web-server-ip"
  resource_group_name = "production-rg"
  location            = "West Europe"
}
```

### Public IP with Custom Domain Name

```hcl
module "web_public_ip" {
  source = "./terraform/elementary_modules/azure/public_ip"
  
  public_ip_name      = "web-frontend-ip"
  resource_group_name = "production-rg"
  location            = "West Europe"
  domain_name_label   = "myapp-frontend"
  
  tags = {
    environment = "production"
    service     = "web-frontend"
  }
}
```

### Dynamic Public IP for Development

```hcl
module "dev_public_ip" {
  source = "./terraform/elementary_modules/azure/public_ip"
  
  public_ip_name      = "dev-vm-ip"
  resource_group_name = "development-rg"
  location            = "East US"
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  
  tags = {
    environment = "development"
  }
}
```

## Important Notes

- **Static allocation** is recommended for production workloads
- **Standard SKU** provides zone redundancy and higher SLA
- **Basic SKU** with **Dynamic allocation** is cost-effective for development
- Domain name label must be unique within the Azure region
- Idle timeout applies only to TCP connections