# Terraform Azure Infrastructure with Terragrunt

## Project Overview
This repository contains reusable Terraform modules for provisioning Azure resources and Terragrunt configurations for managing multi-environment deployments. The project is structured to support both standalone module usage and orchestrated deployments using Terragrunt.

## Repository Structure

```bash
├── terraform/
│   ├── elementary_modules/azure/   # Reusable Terraform modules
│   └── global_module_variables/    # Shared variables (empty)
├── terragrunt/                     # Terragrunt orchestration
│   ├── variables_ollama.hcl       # Global Terragrunt variables
│   └── ollama/                     # Ollama deployment environment
└── exp/                            # Experimental configurations
```

## Available Terraform Modules

### 1. **Azure Resource Group** (`terraform/elementary_modules/azure/resource_group`)
Creates and manages Azure resource groups with configurable timeouts and UUID validation for subscription IDs.

### 2. **Azure Virtual Network** (`terraform/elementary_modules/azure/virtual_network`) 
Provisions virtual networks with configurable subnets for Azure environments.

### 3. **Azure Key Vault** (`terraform/elementary_modules/azure/keyvault`)
Creates Azure Key Vault instances with configurable security settings and access policies.

### 4. **Azure Linux VPS** (`terraform/elementary_modules/azure/vps-linux`)
Example configuration for basic Linux virtual machines with SSH access (needs refactoring for production use).

## Terragrunt Orchestration

The `terragrunt/` directory contains orchestrated infrastructure deployments:

### Ollama Environment (`terragrunt/ollama/`)
A complete Ollama deployment environment with dependency management:

- **Resource Group** (`resource_group/`) - Base infrastructure
- **Virtual Network** (`network/`) - Network foundation (depends on RG)  
- **Key Vault** (`keyvault/`) - Secrets management (depends on RG)
- **Virtual Machine** (`vm/`) - Compute resources (depends on RG, Network, Key Vault)

## Usage Instructions

### Using Individual Terraform Modules

```hcl
# Example: Resource Group
module "azure_resource_group" {
  source = "./terraform/elementary_modules/azure/resource_group"

  rg_name         = "my-rg"
  subscription_id = "11111111-1111-1111-1111-111111111111"
  location        = "westeurope"
}

# Example: Virtual Network
module "azure_vnet" {
  source = "./terraform/elementary_modules/azure/virtual_network"

  vnet_name       = "my-vnet"
  location        = "westeurope"  
  rg_name         = module.azure_resource_group.resource_group_name
  address_space   = ["10.0.0.0/16"]
  subnet_names    = ["default-subnet"]
  subnet_prefixes = ["10.0.1.0/24"]
}
```

### Using Terragrunt for Orchestrated Deployments

1. **Deploy all components:**
   ```bash
   cd terragrunt/ollama
   terragrunt run-all plan
   terragrunt run-all apply
   ```

2. **Deploy individual components:**
   ```bash
   cd terragrunt/ollama/resource_group
   terragrunt plan
   terragrunt apply
   ```

3. **Configuration:**
   - Global settings are defined in `variables_ollama.hcl`
   - Each component has its own `terragrunt.hcl` with dependencies
   - Terragrunt automatically handles dependency order and state management

### Prerequisites
- Terraform >= 1.0
- Terragrunt >= 0.45.0
- Azure CLI authenticated  
- Subscription IDs must follow UUID format (`11111111-1111-1111-1111-111111111111`)

## Project Features

### Infrastructure as Code Benefits
- **Modular Design**: Reusable modules for common Azure resources
- **Dependency Management**: Terragrunt handles complex resource dependencies
- **Environment Consistency**: Standardized deployments across environments
- **State Management**: Automatic remote state configuration with Terragrunt
- **Validation**: Built-in validation for Azure subscription IDs and resource parameters

### Current Limitations
- `vps-linux` module requires refactoring for production use (hardcoded values)
- `global_module_variables` directory is empty and needs population
- Limited testing coverage for modules

## Development Guidelines
- Follow Terraform best practices for module structuring
- Maintain consistent naming conventions across all resources  
- Ensure all variables have clear descriptions and validation blocks
- Add comprehensive testing for each module implementation
- Document dependencies clearly in Terragrunt configurations
- Use mock outputs for Terragrunt plan operations

## Troubleshooting

### Common Issues
1. **Terragrunt dependency errors**: Ensure dependencies are properly defined with mock outputs
2. **Azure authentication**: Run `az login` and verify subscription access
3. **Module path errors**: Check relative paths in Terragrunt source references
4. **UUID validation failures**: Verify subscription and tenant IDs follow UUID format

### Getting Help
- Check module-specific README files for detailed usage instructions
- Review Terragrunt logs for dependency resolution issues
- Validate Terraform configurations before running Terragrunt commands

## Contributing
1. Fork the repository
2. Create a new branch for your feature
3. Add tests for any new functionality  
4. Update documentation in module README files
5. Test with both Terraform and Terragrunt workflows
6. Submit a pull request with clear description of changes
