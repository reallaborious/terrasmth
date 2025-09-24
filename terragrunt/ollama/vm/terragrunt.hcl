include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "rg" {
  config_path = "../resource_group"
}

dependency "network" {
  config_path = "../network"
}

dependency "keyvault" {
  config_path = "../keyvault"
}

terraform {
  source = "../../../terraform/elementary_modules/azure/vm_gpu"
}

inputs = {
  resource_group_name = dependency.rg.outputs.resource_group_name
  location            = "westeurope"
  subnet_id           = dependency.network.outputs.subnet_ids[0]
  admin_ssh_key_name  = "ollama-ssh"
  key_vault_name      = "ollama-kv"
  vm_name             = "ollama-gpu-vm"
  vm_size             = "Standard_NC6"
  tags = { environment = "ollama" }
}