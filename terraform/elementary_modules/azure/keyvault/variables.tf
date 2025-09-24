# This file defines the input variables for the Azure Key Vault module.

variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Key Vault will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault will be located."
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Key Vault. Possible values are 'standard' or 'premium'."
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  type        = string
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained while soft deleted."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Is purge protection enabled for this Key Vault?"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}