# Azure Linux Virtual Machine Module

This module creates a Linux virtual machine in Azure with configurable parameters. It's designed to work with other elementary modules for networking components (network interfaces, public IPs, security groups) created separately.

## Features

- **Modular Design**: Works with existing network interfaces (created by `network_interface` module)
- **SSH Authentication**: Supports SSH key-based authentication with optional password authentication
- **Configurable VM Sizes**: Support for various Azure VM sizes with validation
- **Flexible OS Disk**: Configurable storage type, caching, and disk size
- **Source Image Options**: Configurable OS image (defaults to Ubuntu 22.04 LTS)
- **Boot Diagnostics**: Optional boot diagnostics support
- **Tagging Support**: Apply custom tags to resources

## Architecture

This module creates only the virtual machine resource and depends on:
- Network interfaces (created by `network_interface` module)
- Resource group (created by `resource_group` module)
- Virtual network and subnets (created by `virtual_network` module)

## Usage

```hcl
module "linux_vm" {
  source = "./terraform/elementary_modules/azure/vps-linux"
  
  # Required variables
  vm_name               = "ollama-vm"
  resource_group_name   = "ollama-rg"
  location             = "East US"
  network_interface_ids = [module.network_interface.id]
  
  # SSH configuration
  admin_username = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
  
  # VM configuration
  vm_size = "Standard_D2s_v3"
  
  # Optional: Custom OS disk configuration
  os_disk_storage_account_type = "Premium_LRS"
  os_disk_size_gb             = 128
  
  # Optional: Custom source image
  source_image_publisher = "Canonical"
  source_image_offer     = "0001-com-ubuntu-server-jammy"
  source_image_sku       = "22_04-lts"
  source_image_version   = "latest"
  
  # Optional: Tags
  tags = {
    Environment = "development"
    Project     = "ollama"
  }
  
  subscription_id = "11111111-1111-1111-1111-111111111111"
}
```

## Complete Infrastructure Example

```hcl
# Create all required networking components and VM
module "resource_group" {
  source = "./terraform/elementary_modules/azure/resource_group"
  
  name     = "ollama-rg"
  location = "East US"
}

module "virtual_network" {
  source = "./terraform/elementary_modules/azure/virtual_network"
  
  name                = "ollama-vnet"
  location           = module.resource_group.location
  resource_group_name = module.resource_group.name
  address_space      = ["10.0.0.0/16"]
  
  subnets = [
    {
      name             = "default"
      address_prefixes = ["10.0.1.0/24"]
    }
  ]
}

module "public_ip" {
  source = "./terraform/elementary_modules/azure/public_ip"
  
  name                = "ollama-vm-pip"
  resource_group_name = module.resource_group.name
  location           = module.resource_group.location
  allocation_method  = "Static"
  sku               = "Standard"
}

module "network_security_group" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  name                = "ollama-vm-nsg"
  location           = module.resource_group.location
  resource_group_name = module.resource_group.name
  
  security_rules = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                 = "Inbound"
      access                    = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "22"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }
  ]
}

module "network_interface" {
  source = "./terraform/elementary_modules/azure/network_interface"
  
  name                = "ollama-vm-nic"
  location           = module.resource_group.location
  resource_group_name = module.resource_group.name
  
  ip_configurations = [
    {
      name                          = "internal"
      subnet_id                     = module.virtual_network.subnet_ids["default"]
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id         = module.public_ip.id
    }
  ]
}

module "nsg_subnet_association" {
  source = "./terraform/elementary_modules/azure/nsg_subnet_association"
  
  subnet_id                    = module.virtual_network.subnet_ids["default"]
  network_security_group_id    = module.network_security_group.id
}

module "linux_vm" {
  source = "./terraform/elementary_modules/azure/vps-linux"
  
  vm_name               = "ollama-vm"
  resource_group_name   = module.resource_group.name
  location             = module.resource_group.location
  network_interface_ids = [module.network_interface.id]
  
  admin_username = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
  vm_size       = "Standard_D2s_v3"
  
  tags = {
    Environment = "development"
    Project     = "ollama"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.75 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.75 |

## Resources

| Name | Type |
|------|------|
| azurerm_linux_virtual_machine.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vm_name | Name of the Linux virtual machine | `string` | n/a | yes |
| resource_group_name | Name of the resource group where the VM will be created | `string` | n/a | yes |
| location | Azure region where the VM will be created | `string` | n/a | yes |
| network_interface_ids | List of network interface IDs to attach to the VM | `list(string)` | n/a | yes |
| admin_username | Administrator username for the VM | `string` | `"adminuser"` | no |
| vm_size | Size of the virtual machine | `string` | `"Standard_B2s"` | no |
| disable_password_authentication | Whether to disable password authentication in favor of SSH keys | `bool` | `true` | no |
| ssh_public_key | SSH public key for authentication. If null, password authentication will be used | `string` | `null` | no |
| os_disk_caching | Caching type for the OS disk | `string` | `"ReadWrite"` | no |
| os_disk_storage_account_type | Storage account type for the OS disk | `string` | `"Standard_LRS"` | no |
| os_disk_size_gb | Size of the OS disk in GB. If null, uses the default size from the image | `number` | `null` | no |
| source_image_publisher | Publisher of the source image | `string` | `"Canonical"` | no |
| source_image_offer | Offer of the source image | `string` | `"0001-com-ubuntu-server-jammy"` | no |
| source_image_sku | SKU of the source image | `string` | `"22_04-lts"` | no |
| source_image_version | Version of the source image | `string` | `"latest"` | no |
| boot_diagnostics_storage_account_uri | Storage account URI for boot diagnostics. If null, boot diagnostics will be disabled | `string` | `null` | no |
| tags | Tags to apply to the virtual machine | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the Linux virtual machine |
| name | Name of the Linux virtual machine |
| private_ip_address | Primary private IP address of the virtual machine |
| private_ip_addresses | List of all private IP addresses of the virtual machine |
| public_ip_address | Primary public IP address of the virtual machine |
| public_ip_addresses | List of all public IP addresses of the virtual machine |
| virtual_machine_id | Unique identifier of the virtual machine |
| identity | Identity block of the virtual machine |

## Dependencies

This module requires the following resources to be created beforehand:
- **Resource Group**: Use the `resource_group` module
- **Network Interfaces**: Use the `network_interface` module
- **Virtual Network**: Use the `virtual_network` module (for subnets)
- **Public IP** (optional): Use the `public_ip` module
- **Network Security Groups** (optional): Use the `network_security_group` and `nsg_subnet_association` modules

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