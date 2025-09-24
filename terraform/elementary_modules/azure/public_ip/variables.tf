variable "public_ip_name" {
  description = "The name of the public IP address"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the public IP will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the public IP will be located"
  type        = string
}

variable "allocation_method" {
  description = "The allocation method for the public IP address. Possible values are 'Static' or 'Dynamic'"
  type        = string
  default     = "Static"
  
  validation {
    condition     = contains(["Static", "Dynamic"], var.allocation_method)
    error_message = "Allocation method must be either 'Static' or 'Dynamic'."
  }
}

variable "sku" {
  description = "The SKU of the public IP address. Possible values are 'Basic' or 'Standard'"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "SKU must be either 'Basic' or 'Standard'."
  }
}

variable "domain_name_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN"
  type        = string
  default     = null
}

variable "idle_timeout_in_minutes" {
  description = "Specifies the timeout for the TCP idle connection"
  type        = number
  default     = 4
  
  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 30
    error_message = "Idle timeout must be between 4 and 30 minutes."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}