terraform {
  source = "../../../terraform/elementary_modules/azure/build_vm"
}

include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

# Dependencies - this build VM needs network infrastructure and ACR
dependencies {
  paths = [
    "../resource_group",
    "../network",
    "../network_security_group", 
    "../container_registry",
    "../public_ip"
  ]
}

dependency "resource_group" {
  config_path = "../resource_group"
  mock_outputs = {
    resource_group_name = "mock-rg"
  }
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    subnet_ids = ["mock-subnet-id"]
  }
}

dependency "container_registry" {
  config_path = "../container_registry"
  mock_outputs = {
    name = "mock-acr"
  }
}

dependency "public_ip" {
  config_path = "../public_ip"
  mock_outputs = {
    public_ip_id = "/subscriptions/24246c45-86af-407e-993c-1883f8735933/resourceGroups/hunyuan3d-2gp-rg/providers/Microsoft.Network/publicIPAddresses/hunyuan3d-2gp-build-vm-ip"
  }
}

dependency "network_security_group" {
  config_path = "../network_security_group"
  mock_outputs = {
    network_security_group_id = "/subscriptions/24246c45-86af-407e-993c-1883f8735933/resourceGroups/hunyuan3d-2gp-rg/providers/Microsoft.Network/networkSecurityGroups/hunyuan3d-2gp-nsg"
  }
}

# Generate SSH key pair for the build VM
# This module uses the dedicated build_vm module

inputs = {
  # Basic VM configuration
  vm_name             = "${local.config.locals.project_name}-build-vm"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = local.config.locals.location
  
  # Network configuration
  subnet_id                 = dependency.network.outputs.subnet_ids[0]
  public_ip_id              = dependency.public_ip.outputs.public_ip_id
  network_security_group_id = dependency.network_security_group.outputs.network_security_group_id
  
  # ACR configuration
  acr_name = dependency.container_registry.outputs.name
  
  # VM specs - good for Docker builds
  vm_size = "Standard_D4s_v3"  # 4 vCPU, 16 GB RAM
  
  # Admin user
  admin_username = "builduser"
}