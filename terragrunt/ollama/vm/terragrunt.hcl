include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

locals {
  root      = read_terragrunt_config(find_in_parent_folders("variables_ollama.hcl"))
  ssh_user  = try(local.root.locals.ssh_user, get_env("TF_SSH_USER", "ollama"))
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
  source = "../../../terraform/elementary_modules/azure/vps-linux"
}

inputs = {
  vm_name               = "ollama-vm"
  resource_group_name   = dependency.rg.outputs.resource_group_name
  location             = dependency.rg.outputs.location
  network_interface_ids = [dependency.network_interface.outputs.network_interface_id]
  
  # VM Configuration
  # Use universal SSH user from variables_ollama.hcl locals
  admin_username = local.ssh_user
  # Avoid local file dependency during validate; allow env override
  ssh_public_key = get_env("TF_SSH_PUBLIC_KEY", null)
  vm_size       = get_env("TF_VM_SIZE", "Standard_B4ms")
  #vm_size       = "Standard_B4ms"  # 4 vCPUs, 16 GB RAM - matches vm script
  
  # OS Disk Configuration
  os_disk_storage_account_type = "Premium_LRS"
  os_disk_size_gb             = 128
  
  # Ubuntu 20.04 LTS configuration - matches vm script
  source_image_publisher = "Canonical"
  source_image_offer     = "0001-com-ubuntu-server-focal" 
  source_image_sku       = "20_04-lts"
  source_image_version   = "latest"

  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "virtual-machine"
  }
}
