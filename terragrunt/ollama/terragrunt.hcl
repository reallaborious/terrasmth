include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

# Orchestrator only (no terraform {} / no inputs here).
# Run:
#   terragrunt run-all plan
# or cd into a component dir (resource_group, network, keyvault, vm) and run terragrunt plan there.
