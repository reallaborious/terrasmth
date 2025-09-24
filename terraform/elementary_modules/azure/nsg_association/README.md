# Azure NSG Association Terraform Module

This module creates associations between Azure Network Security Groups and either subnets or network interfaces.

## Usage

### Associate NSG with Subnet

```hcl
module "subnet_nsg_association" {
  source = "./terraform/elementary_modules/azure/nsg_association"
  
  network_security_group_id = module.web_nsg.network_security_group_id
  subnet_id                 = module.virtual_network.subnet_ids[0]
}
```

### Associate NSG with Network Interface

```hcl
module "nic_nsg_association" {
  source = "./terraform/elementary_modules/azure/nsg_association"
  
  network_security_group_id = module.database_nsg.network_security_group_id
  network_interface_id      = module.database_nic.network_interface_id
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
| azurerm_subnet_network_security_group_association.subnet | resource |
| azurerm_network_interface_security_group_association.network_interface | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network_security_group_id | The ID of the network security group to associate | `string` | n/a | yes |
| subnet_id | The ID of the subnet to associate with the NSG (mutually exclusive with network_interface_id) | `string` | `null` | no |
| network_interface_id | The ID of the network interface to associate with the NSG (mutually exclusive with subnet_id) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| subnet_association_id | The ID of the subnet NSG association (if created) |
| network_interface_association_id | The ID of the network interface NSG association (if created) |
| association_type | The type of association created ('subnet' or 'network_interface') |

## Examples

### Web Tier with Subnet-Level NSG

```hcl
# Create NSG for web tier
module "web_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "web-tier-nsg"
  resource_group_name         = "production-rg"
  location                   = "West Europe"
  
  security_rules = [
    {
      name                       = "AllowHTTP"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowHTTPS"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

# Associate NSG with web subnet
module "web_subnet_nsg_association" {
  source = "./terraform/elementary_modules/azure/nsg_association"
  
  network_security_group_id = module.web_nsg.network_security_group_id
  subnet_id                 = module.virtual_network.subnet_ids[0]  # Web subnet
}
```

### Database Server with NIC-Level NSG

```hcl
# Create restrictive NSG for database server
module "database_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "database-nsg"
  resource_group_name         = "production-rg"
  location                   = "West Europe"
  
  security_rules = [
    {
      name                       = "AllowDatabaseFromAppTier"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3306"  # MySQL
      source_address_prefix      = "10.0.1.0/24"  # App tier subnet
      destination_address_prefix = "*"
    },
    {
      name                       = "DenyAllOtherInbound"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

# Create database server network interface
module "database_nic" {
  source = "./terraform/elementary_modules/azure/network_interface"
  
  network_interface_name = "database-nic"
  resource_group_name    = "production-rg"
  location              = "West Europe"
  
  ip_configurations = [{
    name                          = "database-config"
    subnet_id                     = module.virtual_network.subnet_ids[2]  # Database subnet
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
    primary                       = true
  }]
}

# Associate NSG with database NIC for granular control
module "database_nic_nsg_association" {
  source = "./terraform/elementary_modules/azure/nsg_association"
  
  network_security_group_id = module.database_nsg.network_security_group_id
  network_interface_id      = module.database_nic.network_interface_id
}
```

### GPU Compute VM with Multiple NSG Layers

```hcl
# Subnet-level NSG for general compute security
module "compute_subnet_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "compute-subnet-nsg"
  resource_group_name         = "ai-workload-rg"
  location                   = "East US"
  
  security_rules = [
    {
      name                       = "AllowSSHFromManagement"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.0.100.0/24"  # Management subnet
      destination_address_prefix = "*"
    }
  ]
}

# NIC-level NSG for specific GPU VM
module "gpu_vm_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "gpu-vm-specific-nsg"
  resource_group_name         = "ai-workload-rg"
  location                   = "East US"
  
  security_rules = [
    {
      name                       = "AllowOllamaAPI"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "11434"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowJupyterNotebook"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8888"
      source_address_prefix      = "10.0.0.0/8"  # Private networks only
      destination_address_prefix = "*"
    }
  ]
}

# Associate subnet-level NSG
module "compute_subnet_association" {
  source = "./terraform/elementary_modules/azure/nsg_association"
  
  network_security_group_id = module.compute_subnet_nsg.network_security_group_id
  subnet_id                 = module.virtual_network.subnet_ids[1]  # Compute subnet
}

# Associate VM-specific NSG to the NIC
module "gpu_vm_nic_association" {
  source = "./terraform/elementary_modules/azure/nsg_association"
  
  network_security_group_id = module.gpu_vm_nsg.network_security_group_id
  network_interface_id      = module.gpu_vm_nic.network_interface_id
}
```

## Important Notes

### Association Types

- **Subnet Association**: Applies NSG rules to all resources in the subnet
- **NIC Association**: Applies NSG rules only to the specific network interface
- **Precedence**: NIC-level NSGs take precedence over subnet-level NSGs

### Best Practices

1. **Defense in Depth**: Use both subnet and NIC-level NSGs for critical resources
2. **Least Privilege**: Start with restrictive rules and open only what's needed
3. **Subnet NSGs**: Good for common security policies across similar resources
4. **NIC NSGs**: Use for resource-specific security requirements
5. **Mutual Exclusivity**: This module enforces that exactly one target (subnet OR NIC) is specified

### Common Patterns

- **Web Tier**: Subnet-level NSG for HTTP/HTTPS traffic
- **App Tier**: Subnet-level NSG with restricted source addresses
- **Database Tier**: NIC-level NSGs for granular database access control
- **Management**: Separate subnet with jump box access patterns
- **GPU/Compute**: Layered approach with both subnet and NIC NSGs

### Validation

The module includes validation to ensure exactly one of `subnet_id` or `network_interface_id` is specified. Providing both or neither will result in an error.