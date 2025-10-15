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
  source = local.cloud == "azure" ? "../../../terraform/elementary_modules/azure/vps-linux" : "../../../terraform/elementary_modules/aws/ec2"
}

inputs = local.cloud == "azure" ? {
  vm_name               = "ollama-vm"
  resource_group_name   = dependency.rg.outputs.resource_group_name
  location              = dependency.rg.outputs.location
  network_interface_ids = [dependency.network_interface.outputs.network_interface_id]
  admin_username        = local.ssh_user
  ssh_public_key        = get_env("TF_SSH_PUBLIC_KEY", "")
  vm_size               = get_env("TF_VM_SIZE", "Standard_B4ms")
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "virtual-machine"
  }
} : {
  region               = dependency.rg.outputs.location
  name                 = "ollama-vm"
  instance_type        = get_env("TF_INSTANCE_TYPE", "t3.micro")
  network_interface_id = dependency.network_interface.outputs.network_interface_id
  ssh_public_key       = get_env("TF_SSH_PUBLIC_KEY", "")
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "virtual-machine"
  }
}
