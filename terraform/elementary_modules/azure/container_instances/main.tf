resource "azurerm_container_group" "aci" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = var.ip_address_type
  dns_name_label      = var.dns_name_label
  os_type             = var.os_type
  restart_policy      = var.restart_policy
  
  dynamic "container" {
    for_each = var.containers
    content {
      name   = container.value.name
      image  = container.value.image
      cpu    = container.value.cpu
      memory = container.value.memory
      
      dynamic "ports" {
        for_each = container.value.ports != null ? container.value.ports : []
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }
      
      environment_variables        = container.value.environment_variables
      secure_environment_variables = container.value.secure_environment_variables
      
      dynamic "volume" {
        for_each = container.value.volumes != null ? container.value.volumes : []
        content {
          name                 = volume.value.name
          mount_path          = volume.value.mount_path
          read_only           = volume.value.read_only
          empty_dir           = volume.value.empty_dir
          storage_account_name = volume.value.storage_account_name
          storage_account_key  = volume.value.storage_account_key
          share_name          = volume.value.share_name
          
          dynamic "git_repo" {
            for_each = volume.value.git_repo != null ? [volume.value.git_repo] : []
            content {
              url       = git_repo.value.url
              directory = git_repo.value.directory
              revision  = git_repo.value.revision
            }
          }
          
          secret = volume.value.secret
        }
      }
      
      dynamic "liveness_probe" {
        for_each = container.value.liveness_probe != null ? [container.value.liveness_probe] : []
        content {
          failure_threshold     = liveness_probe.value.failure_threshold
          initial_delay_seconds = liveness_probe.value.initial_delay_seconds
          period_seconds        = liveness_probe.value.period_seconds
          success_threshold     = liveness_probe.value.success_threshold
          timeout_seconds       = liveness_probe.value.timeout_seconds
          
          dynamic "http_get" {
            for_each = liveness_probe.value.http_get != null ? [liveness_probe.value.http_get] : []
            content {
              path         = http_get.value.path
              port         = http_get.value.port
              scheme       = http_get.value.scheme
              http_headers = http_get.value.http_headers
            }
          }
        }
      }
      
      dynamic "readiness_probe" {
        for_each = container.value.readiness_probe != null ? [container.value.readiness_probe] : []
        content {
          failure_threshold     = readiness_probe.value.failure_threshold
          initial_delay_seconds = readiness_probe.value.initial_delay_seconds
          period_seconds        = readiness_probe.value.period_seconds
          success_threshold     = readiness_probe.value.success_threshold
          timeout_seconds       = readiness_probe.value.timeout_seconds
          
          dynamic "http_get" {
            for_each = readiness_probe.value.http_get != null ? [readiness_probe.value.http_get] : []
            content {
              path         = http_get.value.path
              port         = http_get.value.port
              scheme       = http_get.value.scheme
              http_headers = http_get.value.http_headers
            }
          }
        }
      }
      
      commands = container.value.commands
    }
  }
  
  dynamic "exposed_port" {
    for_each = var.exposed_ports
    content {
      port     = exposed_port.value.port
      protocol = exposed_port.value.protocol
    }
  }
  
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  
  dynamic "image_registry_credential" {
    for_each = var.image_registry_credentials
    content {
      server   = image_registry_credential.value.server
      username = image_registry_credential.value.username
      password = image_registry_credential.value.password
    }
  }
  
  dynamic "dns_config" {
    for_each = var.dns_config != null ? [var.dns_config] : []
    content {
      nameservers    = dns_config.value.nameservers
      search_domains = dns_config.value.search_domains
      options        = dns_config.value.options
    }
  }
  
  dynamic "diagnostics" {
    for_each = var.diagnostics != null ? [var.diagnostics] : []
    content {
      dynamic "log_analytics" {
        for_each = diagnostics.value.log_analytics != null ? [diagnostics.value.log_analytics] : []
        content {
          workspace_id  = log_analytics.value.workspace_id
          workspace_key = log_analytics.value.workspace_key
          log_type      = log_analytics.value.log_type
          metadata      = log_analytics.value.metadata
        }
      }
    }
  }
  
  subnet_ids = var.dns_name_label == null ? var.subnet_ids : null
  
  tags = var.tags
  
  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
    read   = var.timeout_read
  }
}