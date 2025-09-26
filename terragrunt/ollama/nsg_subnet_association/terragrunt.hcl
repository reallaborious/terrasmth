include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    subnet_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet/subnets/mock-subnet"]
  }
}

dependency "nsg" {
  config_path = "../network_security_group"
  
  mock_outputs = {
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/networkSecurityGroups/mock-nsg"
  }
}

terraform {
  source = "../../../terraform/elementary_modules/azure/nsg_subnet_association"
}

inputs = {
  subnet_id                    = dependency.network.outputs.subnet_ids[0]
  network_security_group_id    = dependency.nsg.outputs.network_security_group_id
}