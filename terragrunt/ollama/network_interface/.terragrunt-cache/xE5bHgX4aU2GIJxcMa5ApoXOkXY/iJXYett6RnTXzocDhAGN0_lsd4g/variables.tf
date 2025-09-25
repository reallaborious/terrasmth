variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the network interface will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the network interface will be located"
  type        = string
}

variable "ip_configurations" {
  description = "List of IP configurations for the network interface"
  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
    private_ip_address            = optional(string)
    public_ip_address_id          = optional(string)
    primary                       = optional(bool)
  }))
  
  validation {
    condition = alltrue([
      for config in var.ip_configurations : 
      contains(["Dynamic", "Static"], config.private_ip_address_allocation)
    ])
    error_message = "private_ip_address_allocation must be either 'Dynamic' or 'Static'."
  }
}

variable "dns_servers" {
  description = "A list of IP addresses defining the DNS servers which should be used for this network interface"
  type        = list(string)
  default     = []
}

variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Requires supported VM size"
  type        = bool
  default     = false
}

variable "enable_ip_forwarding" {
  description = "Should IP Forwarding be enabled? Used when the NIC is used for network appliances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}