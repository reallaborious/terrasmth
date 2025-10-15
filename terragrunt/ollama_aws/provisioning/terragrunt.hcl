include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "ec2" {
  config_path = "../ec2"
  mock_outputs = {
    public_ip_address = "1.2.3.4"
    name = "mock-vm"
  }
}

terraform {
  source = "../../terraform/elementary_modules/ansible_provisioner"
}

locals {
  root      = read_terragrunt_config(find_in_parent_folders("variables_ollama.hcl"))
  ssh_user  = try(local.root.locals.ssh_user, get_env("TF_SSH_USER", "ollama"))
}

inputs = {
  target_hosts = [{
    name = dependency.ec2.outputs.name
    ansible_host = dependency.ec2.outputs.public_ip_address
    ansible_user = local.ssh_user
    ansible_ssh_private_key_file = "~/.ssh/id_rsa"
  }]
  
  playbook_path = "${get_terragrunt_dir()}/../ollama/provisioning/ansible/install-ollama.yml"
  inventory_group   = "ollama_servers"
  ansible_become    = true
  ansible_verbosity = 1
  ansible_timeout   = 1800
  ansible_skip_tags = ["models"]
  extra_vars = {
    gpu_enabled = get_env("TF_GPU_ENABLED", "true") == "true"
    gpu_vendor  = get_env("TF_GPU_VENDOR", "nvidia")
    nvidia_cuda_version = get_env("TF_NVIDIA_CUDA_VERSION", "12.4")
    nvidia_container_toolkit = get_env("TF_NVIDIA_CONTAINER_TOOLKIT", "true") == "true"
    ollama_gpu = get_env("TF_OLLAMA_GPU", "true") == "true"
  }
}
