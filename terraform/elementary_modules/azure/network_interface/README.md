# Azure Network Interface Terraform Module

This module creates an Azure Network Interface with configurable IP configurations and advanced networking features.

## Usage

```hcl
module "network_interface" {
  source = "./terraform/elementary_modules/azure/network_interface"
  
  network_interface_name = "vm-nic"
  resource_group_name    = "my-resource-group"
  location              = "West Europe"
  
  ip_configurations = [{
    name                          = "internal"
    subnet_id                     = "/subscriptions/.../subnets/my-subnet"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/.../publicIPAddresses/my-public-ip"
    primary                       = true
  }]
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
| azurerm_network_interface.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network_interface_name | The name of the network interface | `string` | n/a | yes |
| resource_group_name | The name of the resource group where the network interface will be created | `string` | n/a | yes |
| location | The Azure region where the network interface will be located | `string` | n/a | yes |
| ip_configurations | List of IP configurations for the network interface | `list(object)` | n/a | yes |
| dns_servers | A list of IP addresses defining the DNS servers | `list(string)` | `[]` | no |
| enable_accelerated_networking | Should Accelerated Networking be enabled? | `bool` | `false` | no |
| enable_ip_forwarding | Should IP Forwarding be enabled? | `bool` | `false` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

### IP Configuration Object

Each IP configuration object supports:

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| name | Name for this IP configuration | `string` | yes |
| subnet_id | The ID of the subnet | `string` | yes |
| private_ip_address_allocation | Private IP allocation method ('Dynamic' or 'Static') | `string` | yes |
| private_ip_address | Static private IP address (required if allocation is 'Static') | `string` | no |
| public_ip_address_id | ID of the public IP address to associate | `string` | no |
| primary | Is this the primary IP configuration? | `bool` | no |

## Outputs

| Name | Description |
|------|-------------|
| network_interface_id | The ID of the network interface |
| private_ip_address | The first private IP address of the network interface |
| private_ip_addresses | The private IP addresses of the network interface |
| mac_address | The media access control (MAC) address of the network interface |

## Examples

### Basic Network Interface with Dynamic IP

```hcl
module "basic_nic" {
  source = "./terraform/elementary_modules/azure/network_interface"
  
  network_interface_name = "web-server-nic"
  resource_group_name    = "production-rg"
  location              = "West Europe"
  
  ip_configurations = [{
    name                          = "internal"
    subnet_id                     = module.virtual_network.subnet_ids[0]
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }]
}
```

### Network Interface with Static Private IP and Public IP

```hcl
module "static_nic" {
  source = "./terraform/elementary_modules/azure/network_interface"
  
  network_interface_name = "app-server-nic"
  resource_group_name    = "production-rg"
  location              = "West Europe"
  
  ip_configurations = [{
    name                          = "static-config"
    subnet_id                     = module.virtual_network.subnet_ids[0]
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
    public_ip_address_id          = module.public_ip.public_ip_id
    primary                       = true
  }]
  
  tags = {
    environment = "production"
    service     = "application"
  }
}
```

### Network Interface with Multiple IP Configurations

```hcl
module "multi_ip_nic" {
  source = "./terraform/elementary_modules/azure/network_interface"
  
  network_interface_name = "multi-ip-nic"
  resource_group_name    = "production-rg"
  location              = "West Europe"
  
  ip_configurations = [
    {
      name                          = "primary"
      subnet_id                     = module.virtual_network.subnet_ids[0]
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = module.public_ip_primary.public_ip_id
      primary                       = true
    },
    {
      name                          = "secondary"
      subnet_id                     = module.virtual_network.subnet_ids[1]
      private_ip_address_allocation = "Static"
      private_ip_address            = "10.0.2.10"
      primary                       = false
    }
  ]
  
  enable_accelerated_networking = true
  dns_servers                  = ["8.8.8.8", "8.8.4.4"]
}
```

### High-Performance Network Interface

```hcl
module "gpu_vm_nic" {
  source = "./terraform/elementary_modules/azure/network_interface"
  
  network_interface_name = "gpu-vm-nic"
  resource_group_name    = "ai-workload-rg"
  location              = "East US"
  
  ip_configurations = [{
    name                          = "gpu-config"
    subnet_id                     = module.virtual_network.subnet_ids[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = module.public_ip.public_ip_id
    primary                       = true
  }]
  
  enable_accelerated_networking = true  # For GPU workloads
  
  tags = {
    environment = "production"
    workload    = "gpu-compute"
  }
}
```

## Important Notes

- **Primary IP Configuration**: Exactly one IP configuration must be marked as primary
- **Accelerated Networking**: Only supported on specific VM sizes (D/DSv2, D/DSv3, E/ESv3, F/FS, H/HS, and Ms/Mms series)
- **Multiple IPs**: Useful for hosting multiple websites or services on a single VM
- **Static IPs**: Must be within the subnet's address range and not already allocated
- **DNS Servers**: If not specified, Azure-provided DNS will be used