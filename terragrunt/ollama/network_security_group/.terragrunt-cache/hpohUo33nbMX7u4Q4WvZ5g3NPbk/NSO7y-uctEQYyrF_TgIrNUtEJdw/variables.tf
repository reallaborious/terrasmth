variable "network_security_group_name" {
  description = "The name of the network security group"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the NSG will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the NSG will be located"
  type        = string
}

variable "security_rules" {
  description = "List of security rules for the network security group"
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = []
  
  validation {
    condition = alltrue([
      for rule in var.security_rules : 
      contains(["Inbound", "Outbound"], rule.direction)
    ])
    error_message = "Direction must be either 'Inbound' or 'Outbound'."
  }
  
  validation {
    condition = alltrue([
      for rule in var.security_rules : 
      contains(["Allow", "Deny"], rule.access)
    ])
    error_message = "Access must be either 'Allow' or 'Deny'."
  }
  
  validation {
    condition = alltrue([
      for rule in var.security_rules : 
      contains(["Tcp", "Udp", "Icmp", "Esp", "Ah", "*"], rule.protocol)
    ])
    error_message = "Protocol must be one of: 'Tcp', 'Udp', 'Icmp', 'Esp', 'Ah', or '*'."
  }
  
  validation {
    condition = alltrue([
      for rule in var.security_rules : 
      rule.priority >= 100 && rule.priority <= 4096
    ])
    error_message = "Priority must be between 100 and 4096."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}