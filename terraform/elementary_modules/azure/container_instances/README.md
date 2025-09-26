# Azure Container Instances Module

This module creates an Azure Container Group for running containers in Azure Container Instances (ACI) with comprehensive configuration options for containers, networking, security, and monitoring.

## Features

- Support for multiple containers within a single container group
- Flexible networking options (Public, Private, None)
- Volume mounting with various storage options (Azure Files, Git repo, Empty dir, Secrets)
- Health probes (liveness and readiness)
- Managed identity integration
- Private container registry authentication
- DNS configuration and custom domains
- Log Analytics integration for monitoring
- Subnet deployment for VNet integration

## Usage

### Basic Single Container

```hcl
module "container_instances" {
  source = "../../terraform/elementary_modules/azure/container_instances"
  
  name                = "my-container-group"
  location           = "East US"
  resource_group_name = "my-resource-group"
  
  containers = [
    {
      name   = "web-app"
      image  = "nginx:latest"
      cpu    = 0.5
      memory = 1.5
      
      ports = [
        {
          port     = 80
          protocol = "TCP"
        }
      ]
    }
  ]
  
  exposed_ports = [
    {
      port     = 80
      protocol = "TCP"
    }
  ]
  
  tags = {
    Environment = "Production"
    Application = "WebServer"
  }
}
```

### Advanced Multi-Container Configuration

```hcl
module "container_instances" {
  source = "../../terraform/elementary_modules/azure/container_instances"
  
  name                = "hunyuan3d-container-group"
  location           = "East US"
  resource_group_name = "ai-workloads-rg"
  dns_name_label     = "hunyuan3d-demo"
  
  containers = [
    {
      name   = "hunyuan3d-app"
      image  = "myregistry.azurecr.io/hunyuan3d-2gp:latest"
      cpu    = 4
      memory = 16
      
      ports = [
        {
          port     = 8000
          protocol = "TCP"
        }
      ]
      
      environment_variables = {
        MODEL_PATH = "/models"
        GPU_COUNT  = "1"
      }
      
      secure_environment_variables = {
        API_KEY = "your-secure-api-key"
      }
      
      volumes = [
        {
          name                 = "model-storage"
          mount_path          = "/models"
          storage_account_name = "mystorageaccount"
          storage_account_key  = "storage-key"
          share_name          = "models"
        },
        {
          name       = "config"
          mount_path = "/config"
          secret = {
            "config.json" = base64encode(jsonencode({
              "model_config": "production"
            }))
          }
        }
      ]
      
      liveness_probe = {
        http_get = {
          path = "/health"
          port = 8000
        }
        initial_delay_seconds = 30
        period_seconds        = 30
      }
      
      readiness_probe = {
        http_get = {
          path = "/ready"
          port = 8000
        }
        initial_delay_seconds = 10
        period_seconds        = 5
      }
    },
    {
      name   = "sidecar-proxy"
      image  = "nginx:alpine"
      cpu    = 0.1
      memory = 0.2
      
      ports = [
        {
          port     = 80
          protocol = "TCP"
        }
      ]
    }
  ]
  
  exposed_ports = [
    {
      port     = 80
      protocol = "TCP"
    },
    {
      port     = 8000
      protocol = "TCP"
    }
  ]
  
  image_registry_credentials = [
    {
      server   = "myregistry.azurecr.io"
      username = "myregistry"
      password = var.acr_password
    }
  ]
  
  identity = {
    type = "SystemAssigned"
  }
  
  diagnostics = {
    log_analytics = {
      workspace_id  = var.log_analytics_workspace_id
      workspace_key = var.log_analytics_workspace_key
    }
  }
  
  tags = {
    Environment = "Production"
    Application = "Hunyuan3D"
    Owner       = "AI-Team"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | 3.75.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 3.75.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Specifies the name of the Container Group. | `string` | n/a | yes |
| location | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| resource_group_name | The name of the resource group in which to create the Container Group. | `string` | n/a | yes |
| containers | List of containers in the container group. | `list(object)` | n/a | yes |
| ip_address_type | Specifies the IP address type of the container. Public, Private or None. | `string` | `"Public"` | no |
| dns_name_label | The DNS label/name for the container group's IP. | `string` | `null` | no |
| os_type | The OS for the container group. Allowed values are Linux and Windows. | `string` | `"Linux"` | no |
| restart_policy | Restart policy for the container group. Allowed values are Always, Never, OnFailure. | `string` | `"Always"` | no |
| exposed_ports | A set of public ports for the container group. | `list(object)` | `[]` | no |
| identity | An identity block to configure managed identity for the container group. | `object` | `null` | no |
| image_registry_credentials | A list of image registry credentials for the container group. | `list(object)` | `[]` | no |
| dns_config | A dns_config block to configure DNS for the container group. | `object` | `null` | no |
| diagnostics | A diagnostics block to configure logging for the container group. | `object` | `null` | no |
| subnet_ids | A list of subnet IDs in which the container group will be placed. | `list(string)` | `[]` | no |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| timeout_create | Timeout for create operations | `string` | `"30m"` | no |
| timeout_update | Timeout for update operations | `string` | `"30m"` | no |
| timeout_delete | Timeout for delete operations | `string` | `"30m"` | no |
| timeout_read | Timeout for read operations | `string` | `"5m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Container Group. |
| name | The name of the Container Group. |
| ip_address | The IP address allocated to the container group. |
| fqdn | The FQDN of the container group derived from dns_name_label. |
| identity | An identity block, which contains the Managed Service Identity information for this Container Group. |

## Container Configuration

Each container in the `containers` list supports the following configuration:

- **Basic Settings**: name, image, cpu, memory
- **Networking**: ports with protocol configuration
- **Environment**: regular and secure environment variables
- **Commands**: custom command override
- **Storage**: multiple volume types (Azure Files, Git repos, secrets, empty directories)
- **Health Checks**: liveness and readiness probes with HTTP/exec options

## Volume Types

- **Azure Files**: Mount Azure Storage File shares
- **Git Repository**: Clone and mount git repositories
- **Secrets**: Mount base64-encoded secrets as files
- **Empty Directory**: Temporary storage shared between containers

## Networking Options

- **Public**: Container group gets a public IP address
- **Private**: Container group deployed to a subnet (requires VNet integration)
- **None**: No IP address assigned

## Notes

- Container group names must be unique within the resource group
- CPU and memory resources are allocated per container
- Health probes help ensure container reliability and proper load balancing
- Private registry credentials are marked as sensitive
- Log Analytics integration provides comprehensive monitoring capabilities