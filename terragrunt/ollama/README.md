# Ollama Terragrunt Module

## Overview

This module orchestrates the deployment of the full Ollama infrastructure on Azure using Terragrunt. It manages resource creation in a dependency graph, ensuring resources are created in the correct order.

### Deployment Order

1. **resource_group**: Creates the Azure resource group.
2. **network**, **keyvault**, **network_security_group**, **public_ip**: These are created in parallel after the resource group.
3. **network_interface**, **nsg_subnet_association**: Created in parallel after the above.
4. **vm**: Deploys the virtual machine.
5. **provisioning**: Runs Ansible to install Ollama on the VM.

### How to Use

- To deploy all resources:
  ```
  terragrunt apply --all
  ```
- To destroy all resources:
  ```
  terragrunt destroy --all
  ```

### Submodules

- `resource_group`: Azure resource group for all resources.
- `network`: Virtual network for the VM.
- `keyvault`: Azure Key Vault for secrets.
- `network_security_group`: NSG for controlling VM access.
- `public_ip`: Public IP for the VM.
- `network_interface`: Network interface for the VM.
- `nsg_subnet_association`: Associates NSG with subnet.
- `vm`: The GPU-enabled VM for Ollama.
- `provisioning`: Ansible playbook to install Ollama.

### Variables

Variables are loaded from `variables_ollama.hcl` in the parent directory.

### Notes

- Ensure you have the necessary Azure credentials configured.
- The provisioning step uses Ansible to install Ollama after the VM is created.
