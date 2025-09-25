include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "vm" {
  config_path = "../vm"
  
  mock_outputs = {
    public_ip_address = "1.2.3.4"
    private_ip_address = "10.0.1.4"
    name = "mock-vm"
  }
}

terraform {
  source = "../../../terraform/elementary_modules/ansible_provisioner"
}

inputs = {
  target_hosts = [{
    name = dependency.vm.outputs.name
    ansible_host = dependency.vm.outputs.public_ip_address
    ansible_user = "azureuser"
    ansible_ssh_private_key_file = "~/.ssh/id_rsa"
  }]
  
  playbook_path = "${get_terragrunt_dir()}/ansible/install-ollama.yml"
  
  tags = {
    Component = "provisioning"
    Purpose = "ollama-installation"
  }
}