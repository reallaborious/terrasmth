include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

locals {
  root      = read_terragrunt_config(find_in_parent_folders("variables_ollama.hcl"))
  ssh_user  = try(local.root.locals.ssh_user, get_env("TF_SSH_USER", "ollama"))
  cloud     = try(local.root.locals.cloud, get_env("CLOUD", get_env("AWS_REGION", "") != "" ? "aws" : "azure"))
}

dependency "rg" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "mock-rg"
    location           = "eastus"
  }
}

dependency "network_interface" {
  config_path = "../network_interface"
  
  mock_outputs = {
    network_interface_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/networkInterfaces/mock-nic"
  }
}

dependency "nsg_association" {
  config_path = "../nsg_subnet_association"
  
  mock_outputs = {}
}

terraform {
  source = "../../../terraform/elementary_modules/cloud/compute"
  include_in_copy = [
    "../../../terraform/elementary_modules/aws",
    "../../../terraform/elementary_modules/azure"
  ]
}

inputs = {
  cloud                = local.cloud
  vm_name              = "ollama-vm"
  rg_name              = dependency.rg.outputs.resource_group_name
  location             = dependency.rg.outputs.location
  network_interface_id = dependency.network_interface.outputs.network_interface_id
  
  # VM Configuration
  admin_username  = local.ssh_user
  ssh_public_key  = get_env("TF_SSH_PUBLIC_KEY", "")
  vm_size         = get_env("TF_VM_SIZE", "Standard_B4ms")
  instance_type   = get_env("TF_INSTANCE_TYPE", "t3.micro")
  
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "virtual-machine"
  }
}
