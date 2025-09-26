include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

# Orchestrator with dependency graph for complete Ollama infrastructure
# Deployment order:
# 1. resource_group
# 2. network, keyvault, network_security_group, public_ip (parallel)
# 3. network_interface, nsg_subnet_association (parallel)
# 4. vm
# 5. provisioning (Ansible Ollama installation)
#
# Run:
#   terragrunt apply --all

dependencies {
  paths = [
    "./resource_group",
    "./network",
    "./keyvault", 
    "./network_security_group",
    "./public_ip",
    "./network_interface",
    "./nsg_subnet_association",
    "./vm",
    "./provisioning"
  ]
}
