variable "network_security_group_id" {
  description = "The ID of the network security group to associate"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the NSG. Mutually exclusive with network_interface_id"
  type        = string
  default     = null
}

variable "network_interface_id" {
  description = "The ID of the network interface to associate with the NSG. Mutually exclusive with subnet_id"
  type        = string
  default     = null
}

# Validation to ensure exactly one target is specified
locals {
  targets_specified = length(compact([var.subnet_id, var.network_interface_id]))
  
  validation_check = local.targets_specified == 1 ? true : tobool("Error: exactly one of subnet_id or network_interface_id must be specified, but not both")
}