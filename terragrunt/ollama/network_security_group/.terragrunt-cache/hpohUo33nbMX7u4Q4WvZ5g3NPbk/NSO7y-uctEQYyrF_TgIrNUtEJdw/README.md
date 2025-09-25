# Azure Network Security Group Terraform Module

This module creates an Azure Network Security Group with configurable security rules for controlling network traffic.

## Usage

```hcl
module "network_security_group" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "web-nsg"
  resource_group_name         = "my-resource-group"
  location                   = "West Europe"
  
  security_rules = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
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
| azurerm_network_security_group.this | resource |
| azurerm_network_security_rule.rules | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network_security_group_name | The name of the network security group | `string` | n/a | yes |
| resource_group_name | The name of the resource group where the NSG will be created | `string` | n/a | yes |
| location | The Azure region where the NSG will be located | `string` | n/a | yes |
| security_rules | List of security rules for the network security group | `list(object)` | `[]` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

### Security Rule Object

Each security rule object supports:

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| name | Name of the security rule | `string` | yes |
| priority | Priority of the rule (100-4096, lower numbers have higher priority) | `number` | yes |
| direction | Direction of the rule ('Inbound' or 'Outbound') | `string` | yes |
| access | Action to take ('Allow' or 'Deny') | `string` | yes |
| protocol | Network protocol ('Tcp', 'Udp', 'Icmp', 'Esp', 'Ah', or '*') | `string` | yes |
| source_port_range | Source port or range (e.g., "80", "1024-65535", "*") | `string` | no |
| source_port_ranges | List of source port ranges | `list(string)` | no |
| destination_port_range | Destination port or range | `string` | no |
| destination_port_ranges | List of destination port ranges | `list(string)` | no |
| source_address_prefix | Source address prefix (CIDR, IP, or service tag) | `string` | no |
| source_address_prefixes | List of source address prefixes | `list(string)` | no |
| destination_address_prefix | Destination address prefix | `string` | no |
| destination_address_prefixes | List of destination address prefixes | `list(string)` | no |

## Outputs

| Name | Description |
|------|-------------|
| network_security_group_id | The ID of the network security group |
| network_security_group_name | The name of the network security group |
| security_rule_ids | Map of security rule names to their IDs |

## Examples

### Web Server NSG

```hcl
module "web_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "web-server-nsg"
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
    },
    {
      name                       = "AllowSSHFromManagement"
      priority                   = 1010
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.0.100.0/24"  # Management subnet
      destination_address_prefix = "*"
    }
  ]
  
  tags = {
    environment = "production"
    service     = "web"
  }
}
```

### Database NSG with Multiple Port Ranges

```hcl
module "database_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "database-nsg"
  resource_group_name         = "production-rg"
  location                   = "West Europe"
  
  security_rules = [
    {
      name                       = "AllowDatabasePorts"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["1433", "3306", "5432"]  # SQL Server, MySQL, PostgreSQL
      source_address_prefix      = "10.0.1.0/24"  # App tier subnet
      destination_address_prefix = "*"
    },
    {
      name                       = "DenyAllOther"
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
```

### GPU/AI Workload NSG

```hcl
module "gpu_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "gpu-vm-nsg"
  resource_group_name         = "ai-workload-rg"
  location                   = "East US"
  
  security_rules = [
    {
      name                       = "AllowSSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowOllama"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "11434"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowJupyter"
      priority                   = 1003
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8888"
      source_address_prefixes    = ["10.0.0.0/8", "172.16.0.0/12"]  # Private networks only
      destination_address_prefix = "*"
    }
  ]
  
  tags = {
    environment = "production"
    workload    = "ai-compute"
  }
}
```

### Management NSG with Service Tags

```hcl
module "management_nsg" {
  source = "./terraform/elementary_modules/azure/network_security_group"
  
  network_security_group_name = "management-nsg"
  resource_group_name         = "management-rg"
  location                   = "West Europe"
  
  security_rules = [
    {
      name                       = "AllowAzureLoadBalancer"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowVnetInbound"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  ]
}
```

## Important Notes

- **Priority Rules**: Lower numbers = higher priority (100-4096 range)
- **Default Rules**: Azure automatically creates default rules that can't be deleted
- **Service Tags**: Use Azure service tags like "Internet", "VirtualNetwork", "AzureLoadBalancer"
- **Port Ranges**: Can specify single ports ("80"), ranges ("1024-65535"), or "*" for all
- **Multiple Values**: Use `_ranges` and `_prefixes` variants for multiple values
- **Rule Evaluation**: Rules are processed in priority order until a match is found
- **Best Practices**: Follow least privilege principle, use specific source/destination prefixes when possible