include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/container_instances"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

dependency "resource_group" {
  config_path = "../resource_group"
}

dependency "network" {
  config_path = "../network"
}

dependency "storage" {
  config_path = "../storage"
}

dependency "container_registry" {
  config_path = "../container_registry"
}

inputs = {
  name                = "${local.config.locals.project_name}-api"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location           = local.config.locals.location
  
  os_type    = "Linux"
  restart_policy = "Always"
  
  # GPU configuration for 3D generation
  containers = [
    {
      name   = "hunyuan3d-api"
      image  = "${dependency.container_registry.outputs.login_server}/hunyuan3d-2gp:latest"
      cpu    = local.config.locals.container_cpu
      memory = local.config.locals.container_memory
      
      # GPU configuration
      gpu = {
        count = 1
        sku   = "K80"  # Basic GPU for development, upgrade to V100 for production
      }
      
      ports = [
        {
          port     = tonumber(local.config.locals.api_port)
          protocol = "TCP"
        }
      ]
      
      environment_variables = {
        HUNYUAN3D_MEMORY_PROFILE = local.config.locals.memory_profile
        HUNYUAN3D_ENABLE_TEXTURE = local.config.locals.enable_texture
        PYTHONPATH = "/app"
      }
      
      secure_environment_variables = {
        # Add any secure environment variables here
      }
      
      volume_mount = [
        {
          name       = "model-cache"
          mount_path = "/app/.cache"
          read_only  = false
          share_name = local.config.locals.model_share_name
        }
      ]
      
      liveness_probe = {
        http_get = {
          path   = "/docs"  # FastAPI docs endpoint
          port   = tonumber(local.config.locals.api_port)
          scheme = "Http"
        }
        initial_delay_seconds = 60
        period_seconds       = 30
        timeout_seconds      = 10
        failure_threshold    = 3
      }
      
      readiness_probe = {
        http_get = {
          path   = "/docs"
          port   = tonumber(local.config.locals.api_port)
          scheme = "Http"
        }
        initial_delay_seconds = 30
        period_seconds       = 10
        timeout_seconds      = 5
        failure_threshold    = 3
      }
    }
  ]
  
  # Azure Files volume for model persistence
  volume = [
    {
      name                 = "model-cache"
      storage_account_name = dependency.storage.outputs.name
      storage_account_key  = dependency.storage.outputs.primary_access_key
      share_name          = local.config.locals.model_share_name
    }
  ]
  
  # Network configuration
  subnet_ids = [dependency.network.outputs.subnet_ids[0]]
  
  # Image registry credentials
  image_registry_credential = [
    {
      server   = dependency.container_registry.outputs.login_server
      username = dependency.container_registry.outputs.admin_username
      password = dependency.container_registry.outputs.admin_password
    }
  ]
  
  tags = merge(local.config.locals.common_tags, {
    Component = "ContainerInstances"
    Purpose   = "APIServer"
    Profile   = local.config.locals.memory_profile
  })
}