include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "rg" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "mock-rg"
    location           = "eastus"
  }
}

terraform {
  source = "../../../terraform/elementary_modules/azure/network_security_group"
}

inputs = {
  network_security_group_name = "ollama-vm-nsg"
  location                   = dependency.rg.outputs.location
  resource_group_name        = dependency.rg.outputs.resource_group_name
  
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
    },
    {
      name                       = "HTTP"
      priority                   = 1002
      direction                 = "Inbound"
      access                    = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "80"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTPS"
      priority                   = 1003
      direction                 = "Inbound"
      access                    = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "443"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Ollama-API"
      priority                   = 1004
      direction                 = "Inbound"
      access                    = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "11434"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }
  ]
  
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "network-security-group"
  }
}