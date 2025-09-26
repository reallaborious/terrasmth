variable "name" {
  type        = string
  description = "Specifies the name of the Container Group."
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", var.name))
    error_message = "The container group name must start and end with alphanumeric characters and can contain hyphens."
  }
  
  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 63
    error_message = "The container group name must be between 1 and 63 characters long."
  }
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Container Group."
}

variable "ip_address_type" {
  type        = string
  description = "Specifies the IP address type of the container. Public, Private or None."
  default     = "Public"
  
  validation {
    condition     = contains(["Public", "Private", "None"], var.ip_address_type)
    error_message = "The ip_address_type must be Public, Private, or None."
  }
}

variable "dns_name_label" {
  type        = string
  description = "The DNS label/name for the container group's IP."
  default     = null
}

variable "os_type" {
  type        = string
  description = "The OS for the container group. Allowed values are Linux and Windows."
  default     = "Linux"
  
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "The os_type must be Linux or Windows."
  }
}

variable "restart_policy" {
  type        = string
  description = "Restart policy for the container group. Allowed values are Always, Never, OnFailure."
  default     = "Always"
  
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be Always, Never, or OnFailure."
  }
}

variable "containers" {
  type = list(object({
    name   = string
    image  = string
    cpu    = number
    memory = number
    
    ports = optional(list(object({
      port     = number
      protocol = optional(string, "TCP")
    })), [])
    
    environment_variables        = optional(map(string), {})
    secure_environment_variables = optional(map(string), {})
    commands                     = optional(list(string), [])
    
    volumes = optional(list(object({
      name                 = string
      mount_path          = string
      read_only           = optional(bool, false)
      empty_dir           = optional(bool, false)
      storage_account_name = optional(string, null)
      storage_account_key  = optional(string, null)
      share_name          = optional(string, null)
      
      git_repo = optional(object({
        url       = string
        directory = optional(string, null)
        revision  = optional(string, null)
      }), null)
      
      secret = optional(map(string), {})
    })), [])
    
    liveness_probe = optional(object({
      failure_threshold     = optional(number, 3)
      initial_delay_seconds = optional(number, 0)
      period_seconds        = optional(number, 10)
      success_threshold     = optional(number, 1)
      timeout_seconds       = optional(number, 1)
      
      exec = optional(object({
        command = list(string)
      }), null)
      
      http_get = optional(object({
        path         = optional(string, "/")
        port         = number
        scheme       = optional(string, "Http")
        http_headers = optional(map(string), {})
      }), null)
    }), null)
    
    readiness_probe = optional(object({
      failure_threshold     = optional(number, 3)
      initial_delay_seconds = optional(number, 0)
      period_seconds        = optional(number, 10)
      success_threshold     = optional(number, 1)
      timeout_seconds       = optional(number, 1)
      
      exec = optional(object({
        command = list(string)
      }), null)
      
      http_get = optional(object({
        path         = optional(string, "/")
        port         = number
        scheme       = optional(string, "Http")
        http_headers = optional(map(string), {})
      }), null)
    }), null)
  }))
  description = "List of containers in the container group."
  
  validation {
    condition     = length(var.containers) > 0
    error_message = "At least one container must be specified."
  }
}

variable "exposed_ports" {
  type = list(object({
    port     = number
    protocol = optional(string, "TCP")
  }))
  description = "A set of public ports for the container group."
  default     = []
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  description = "An identity block to configure managed identity for the container group."
  default     = null
}

variable "image_registry_credentials" {
  type = list(object({
    server   = string
    username = string
    password = string
  }))
  description = "A list of image registry credentials for the container group."
  default     = []
  sensitive   = true
}

variable "dns_config" {
  type = object({
    nameservers    = list(string)
    search_domains = optional(list(string), [])
    options        = optional(list(string), [])
  })
  description = "A dns_config block to configure DNS for the container group."
  default     = null
}

variable "diagnostics" {
  type = object({
    log_analytics = optional(object({
      workspace_id  = string
      workspace_key = string
      log_type      = optional(string, "ContainerInsights")
      metadata      = optional(map(string), {})
    }), null)
  })
  description = "A diagnostics block to configure logging for the container group."
  default     = null
  sensitive   = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs in which the container group will be placed."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}