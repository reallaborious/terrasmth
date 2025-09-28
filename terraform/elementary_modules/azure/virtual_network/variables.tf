variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "location" {
  description = "The Azure region for the virtual network."
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
}

variable "subnet_names" {
  description = "A list of subnet names."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "A list of address prefixes for the subnets."
  type        = list(string)
}

variable "delegations" {
  description = "A list of delegations for each subnet (null if no delegation needed for that subnet)"
  type = list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))
  default = null
}