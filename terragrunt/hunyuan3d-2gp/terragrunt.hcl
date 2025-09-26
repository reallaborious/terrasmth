include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

# Orchestrator with dependency graph for complete Hunyuan3D-2GP infrastructure
# Deployment order:
# 1. resource_group
# 2. network, keyvault, network_security_group, storage (parallel)
# 3. container_registry
# 4. container_instances
#
# Run:
#   terragrunt run-all plan --terragrunt-working-dir .
#   terragrunt run-all apply --terragrunt-working-dir .

dependencies {
  paths = [
    "./resource_group",
    "./network",
    "./keyvault", 
    "./network_security_group",
    "./storage",
    "./container_registry",
    "./container_instances"
  ]
}