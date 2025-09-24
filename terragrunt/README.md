# Terragrunt Infrastructure Orchestration

This directory contains Terragrunt configurations for orchestrating Azure infrastructure deployments with proper dependency management.

## Structure

```
terragrunt/
├── variables_ollama.hcl          # Global configuration and provider settings
└── ollama/                       # Ollama environment deployment
    ├── terragrunt.hcl           # Environment orchestrator (no resources)
    ├── resource_group/          # Base Azure resource group
    │   └── terragrunt.hcl
    ├── network/                 # Virtual network and subnets
    │   └── terragrunt.hcl
    ├── keyvault/               # Azure Key Vault for secrets
    │   └── terragrunt.hcl
    └── vm/                     # Virtual machine deployment
        └── terragrunt.hcl
```

## Global Configuration (`variables_ollama.hcl`)

Contains shared settings for the entire Ollama environment:

- **Azure Provider Configuration**: Specifies azurerm provider version `~> 3.75.0`
- **Tenant ID**: Mocked for development (`00000000-0000-0000-0000-000000000000`)
- **Subscription ID**: Mocked for development (`11111111-1111-1111-1111-111111111111`)
- **Provider Generation**: Auto-generates `provider.tf` files

## Component Dependencies

The Terragrunt configuration establishes a clear dependency chain:

```
Resource Group (base)
├── Network (depends on RG)
├── Key Vault (depends on RG)
└── VM (depends on RG, Network, Key Vault)
```

### 1. Resource Group (`resource_group/`)
- **Purpose**: Creates the base Azure resource group
- **Outputs**: `resource_group_name`, `location`
- **Dependencies**: None (base resource)

### 2. Virtual Network (`network/`)
- **Purpose**: Creates VNet and subnets for the infrastructure
- **Module Source**: `../../../terraform/elementary_modules/azure/virtual_network`
- **Dependencies**: Resource Group
- **Configuration**:
  - VNet: `ollama-vnet` with address space `10.0.0.0/16`
  - Subnet: `ollama-subnet` with prefix `10.0.1.0/24`

### 3. Key Vault (`keyvault/`)
- **Purpose**: Manages secrets and keys for the infrastructure
- **Module Source**: `../../../terraform/elementary_modules/azure/keyvault`
- **Dependencies**: Resource Group
- **Configuration**:
  - Name: `ollama-kv`
  - SKU: Standard
  - Soft delete retention: 7 days
  - Purge protection: Disabled (development)

### 4. Virtual Machine (`vm/`)
- **Purpose**: Deploys compute resources for Ollama
- **Dependencies**: Resource Group, Network, Key Vault
- **Note**: Configuration incomplete (module source missing)

## Usage Commands

### Deploy Entire Environment
```bash
cd terragrunt/ollama
terragrunt run-all plan
terragrunt run-all apply
```

### Deploy Individual Components
```bash
# Resource group first
cd terragrunt/ollama/resource_group
terragrunt plan
terragrunt apply

# Then network (depends on RG)
cd ../network
terragrunt plan
terragrunt apply

# Key vault (depends on RG)
cd ../keyvault
terragrunt plan
terragrunt apply

# Finally VM (depends on all above)
cd ../vm
terragrunt plan
terragrunt apply
```

### Destroy Environment
```bash
cd terragrunt/ollama
terragrunt run-all destroy
```

## Mock Outputs

Each component includes mock outputs for planning without dependencies:

```hcl
mock_outputs = {
  resource_group_name = "mock-rg"
  location            = "westeurope"
}
mock_outputs_allowed_terraform_commands = ["validate", "plan"]
```

This enables running `terragrunt plan` on individual components without deploying dependencies first.

## Configuration Details

### Provider Settings
- **Azure Provider**: `hashicorp/azurerm ~> 3.75.0`
- **Features Block**: Empty (default Azure provider features)
- **Authentication**: Inherits from Azure CLI (`az login`)

### Environment Settings
- **Location**: `westeurope` (consistent across all resources)
- **Environment Tag**: `ollama` (applied to key vault)
- **Naming Convention**: `ollama-*` prefix for all resources

## Troubleshooting

### Common Issues

1. **Dependency Resolution Errors**
   ```bash
   # Check dependency order
   terragrunt graph-dependencies
   ```

2. **Module Path Errors**
   - Verify relative paths in `source` declarations
   - Ensure module directories exist

3. **Mock Output Mismatches**
   - Ensure mock outputs match actual module outputs
   - Update mocks when modules change

4. **Azure Authentication**
   ```bash
   az login
   az account show  # Verify correct subscription
   ```

### Best Practices

1. **Always Plan First**: Use `terragrunt plan` before applying
2. **Dependency Order**: Deploy dependencies before dependents
3. **State Management**: Terragrunt handles remote state automatically
4. **Environment Isolation**: Keep different environments in separate directories
5. **Mock Testing**: Use mocks to validate configurations without deployments