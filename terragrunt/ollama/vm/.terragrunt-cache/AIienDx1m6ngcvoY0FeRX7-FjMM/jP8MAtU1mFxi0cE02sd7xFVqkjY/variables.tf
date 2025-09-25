# Required variables
variable "vm_name" {
  description = "Name of the Linux virtual machine"
  type        = string
  
  validation {
    condition     = length(var.vm_name) >= 1 && length(var.vm_name) <= 64
    error_message = "VM name must be between 1 and 64 characters"
  }
}

variable "resource_group_name" {
  description = "Name of the resource group where the VM will be created"
  type        = string
}

variable "location" {
  description = "Azure region where the VM will be created"
  type        = string
}

variable "network_interface_ids" {
  description = "List of network interface IDs to attach to the VM"
  type        = list(string)
  
  validation {
    condition     = length(var.network_interface_ids) > 0
    error_message = "At least one network interface ID must be provided"
  }
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "adminuser"
  
  validation {
    condition     = length(var.admin_username) >= 1 && length(var.admin_username) <= 20
    error_message = "Admin username must be between 1 and 20 characters"
  }
}

# VM Configuration
variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "disable_password_authentication" {
  description = "Whether to disable password authentication in favor of SSH keys"
  type        = bool
  default     = true
}

# SSH Configuration
variable "ssh_public_key" {
  description = "SSH public key for authentication. If null, password authentication will be used"
  type        = string
  default     = null
}

# OS Disk Configuration
variable "os_disk_caching" {
  description = "Caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
  
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "OS disk caching must be None, ReadOnly, or ReadWrite"
  }
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS"
  
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.os_disk_storage_account_type)
    error_message = "OS disk storage account type must be Standard_LRS, StandardSSD_LRS, or Premium_LRS"
  }
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB. If null, uses the default size from the image"
  type        = number
  default     = null
  
  validation {
    condition     = var.os_disk_size_gb == null || (var.os_disk_size_gb >= 30 && var.os_disk_size_gb <= 4095)
    error_message = "OS disk size must be between 30 and 4095 GB"
  }
}

# Source Image Configuration
variable "source_image_publisher" {
  description = "Publisher of the source image"
  type        = string
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "Offer of the source image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_sku" {
  description = "SKU of the source image"
  type        = string
  default     = "22_04-lts"
}

variable "source_image_version" {
  description = "Version of the source image"
  type        = string
  default     = "latest"
}

# Optional Configuration
variable "boot_diagnostics_storage_account_uri" {
  description = "Storage account URI for boot diagnostics. If null, boot diagnostics will be disabled"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the virtual machine"
  type        = map(string)
  default     = {}
}
