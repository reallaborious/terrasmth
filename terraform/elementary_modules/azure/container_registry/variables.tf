variable "name" {
  type        = string
  description = "Specifies the name of the Container Registry. Only Alphanumeric characters allowed."
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9]*$", var.name))
    error_message = "The container registry name must contain only alphanumeric characters."
  }
  
  validation {
    condition     = length(var.name) >= 5 && length(var.name) <= 50
    error_message = "The container registry name must be between 5 and 50 characters long."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Container Registry."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "sku" {
  type        = string
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  default     = "Basic"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The sku must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  type        = bool
  description = "Specifies whether the admin user is enabled."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for the container registry."
  default     = true
}

variable "georeplications" {
  type = list(object({
    location                  = string
    zone_redundancy_enabled   = optional(bool, false)
    regional_endpoint_enabled = optional(bool, false)
    tags                      = optional(map(string), {})
  }))
  description = "A list of geo-replications configuration blocks."
  default     = []
}

variable "network_rule_set" {
  type = object({
    default_action = optional(string, "Allow")
    ip_rule = optional(list(object({
      action   = string
      ip_range = string
    })), [])
    virtual_network = optional(list(object({
      action    = string
      subnet_id = string
    })), [])
  })
  description = "A network_rule_set block to restrict access to the container registry."
  default     = null
}

variable "retention_policy" {
  type = object({
    days    = optional(number, 7)
    enabled = optional(bool, false)
  })
  description = "A retention_policy block to configure retention policy for untagged manifests."
  default     = null
}

variable "trust_policy" {
  type = object({
    enabled = optional(bool, false)
  })
  description = "A trust_policy block to configure content trust for the container registry."
  default     = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  description = "An identity block to configure managed identity for the container registry."
  default     = null
}

variable "encryption" {
  type = object({
    enabled            = optional(bool, false)
    key_vault_key_id   = optional(string, null)
    identity_client_id = optional(string, null)
  })
  description = "An encryption block to configure encryption for the container registry."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "acr_tasks" {
  type = list(object({
    name                = string
    source_repository   = string
    source_branch       = optional(string, "main")
    dockerfile_path     = optional(string, "Dockerfile")
    image_names         = list(string)
    context_path        = optional(string, ".")
    enabled             = optional(bool, true)
    trigger_on_commit   = optional(bool, false)
    trigger_on_schedule = optional(string, null)
  }))
  description = "List of ACR tasks to create for building container images"
  default     = []
}