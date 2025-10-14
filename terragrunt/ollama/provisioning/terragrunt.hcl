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

  mock_outputs_merge_with_state = true
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "apply", "destroy"]
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

  # Generic provisioner settings
  inventory_group   = "ollama_servers"
  ansible_become    = true
  ansible_verbosity = 1
  ansible_timeout   = 1800
  ansible_skip_tags = ["models"]

  # Pass playbook-specific variables generically
  extra_vars = {
    ollama_models = [
      "qwen3:latest",
      "qwen2.5:latest", 
      "codellama:latest",
      "deepseek-coder:latest",
      "llama3.2:1b",
      "phi3:latest",
      "mistral:latest"
    ]
    # GPU-related hints for playbooks (read from environment with safe defaults)
    gpu_enabled = get_env("TF_GPU_ENABLED", "true") == "true"
    gpu_vendor  = get_env("TF_GPU_VENDOR", "nvidia")
    nvidia_cuda_version = get_env("TF_NVIDIA_CUDA_VERSION", "12.4")
    nvidia_container_toolkit = get_env("TF_NVIDIA_CONTAINER_TOOLKIT", "true") == "true"
    ollama_gpu = get_env("TF_OLLAMA_GPU", "true") == "true"
  }
}