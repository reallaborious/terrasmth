# Azure Linux VPS Terraform Module

This module provides an example configuration for creating a basic Linux virtual machine in Azure with SSH access. 

**Note**: This module currently contains hardcoded values and is intended as a reference implementation rather than a production-ready reusable module.

## Current Configuration

The module creates:
- Resource Group (`example-resources`)
- Virtual Network (`example-network`) with address space `10.0.0.0/16`
- Subnet (`internal`) with address prefix `10.0.2.0/24`
- Network Interface
- Linux Virtual Machine with Ubuntu 22.04 LTS

## Usage

```hcl
module "linux_vm" {
  source = "./terraform/elementary_modules/azure/vps-linux"
  
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

## Resources

| Name | Type |
|------|------|
| azurerm_resource_group.example | resource |
| azurerm_virtual_network.example | resource |
| azurerm_subnet.example | resource |
| azurerm_network_interface.example | resource |
| azurerm_linux_virtual_machine.example | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| subscription_id | Azure subscription ID used to deploy the Linux VM | `string` | n/a | yes |

## Outputs

Currently no outputs are defined for this module.

## VM Specifications

- **VM Size**: Standard_F2
- **OS**: Ubuntu 22.04 LTS
- **Authentication**: SSH Key (requires `~/.ssh/id_rsa.pub`)
- **Admin User**: `adminuser`
- **Storage**: Standard LRS

## Prerequisites

- SSH key pair must exist at `~/.ssh/id_rsa.pub`
- Azure subscription with appropriate permissions

## Limitations & TODO

This module needs refactoring to be production-ready:

1. **Hardcoded Values**: Resource names, VM size, location are hardcoded
2. **Missing Variables**: No parameterization for resource names, VM size, location
3. **Missing Outputs**: No outputs for VM details, IPs, etc.
4. **Security**: Basic configuration without NSG rules or advanced security
5. **SSH Key Path**: Hardcoded SSH key path

## Future Improvements

To make this a reusable module, consider:

```hcl
# Suggested variable additions
variable "resource_group_name" { ... }
variable "location" { ... }
variable "vm_name" { ... }
variable "vm_size" { ... }
variable "admin_username" { ... }
variable "ssh_public_key_path" { ... }
variable "vnet_address_space" { ... }
variable "subnet_address_prefix" { ... }
```

## Example Usage (Current State)

```hcl
module "example_vm" {
  source = "./terraform/elementary_modules/azure/vps-linux"
  
  subscription_id = "11111111-1111-1111-1111-111111111111"
}
```