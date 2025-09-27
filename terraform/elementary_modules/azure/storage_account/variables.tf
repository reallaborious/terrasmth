variable "name" {
  type        = string
  description = "Specifies the name of the storage account. Must be between 3 and 24 characters in length and use numbers and lower-case letters only."
  
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "The storage account name must be between 3 and 24 characters long and contain only lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium."
  default     = "Standard"
  
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account_tier must be either Standard or Premium."
  }
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  default     = "LRS"
  
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "The account_replication_type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "account_kind" {
  type        = string
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  default     = "StorageV2"
  
  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "The account_kind must be one of: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account."
  default     = "TLS1_2"
  
  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "The min_tls_version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether the public network access is enabled?"
  default     = true
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Allow or disallow nested items within this Account to opt into being public."
  default     = false
}

variable "blob_properties" {
  type = object({
    versioning_enabled       = optional(bool, false)
    change_feed_enabled      = optional(bool, false)
    default_service_version  = optional(string, null)
    last_access_time_enabled = optional(bool, false)
    cors_rule = optional(list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })), [])
    delete_retention_policy = optional(object({
      days = optional(number, 7)
    }), null)
  })
  description = "A blob_properties block to configure blob properties."
  default     = null
}

variable "network_rules" {
  type = object({
    default_action             = optional(string, "Deny")
    bypass                     = optional(set(string), ["AzureServices"])
    ip_rules                   = optional(set(string), [])
    virtual_network_subnet_ids = optional(set(string), [])
  })
  description = "A network_rules block to restrict access to the storage account."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "file_shares" {
  type = list(object({
    name             = string
    quota            = optional(number, 50)
    enabled_protocol = optional(string, "SMB")
    access_tier      = optional(string, "TransactionOptimized")
  }))
  description = "List of file shares to create in the storage account"
  default     = []
}