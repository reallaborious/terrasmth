# Required variables
variable "vm_name" {
  description = "Name of the build virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the VM will be created"
  type        = string
}

variable "location" {
  description = "Azure region where the VM will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be attached"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the public IP to assign to the VM"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry for pushing images"
  type        = string
}

# Optional variables with defaults
variable "vm_size" {
  description = "Size of the virtual machine for building"
  type        = string
  default     = "Standard_D4s_v3"  # 4 vCPU, 16 GB RAM - good for Docker builds
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "builduser"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}