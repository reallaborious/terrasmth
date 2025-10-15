variable "cloud" { type = string }
# Azure
variable "azure_location" { type = string, default = null }
variable "azure_rg_name" { type = string, default = null }
variable "security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

# AWS
variable "aws_region" { type = string, default = null }
variable "vpc_id" { type = string, default = null }
variable "name" { type = string }

variable "tags" { type = map(string) default = {} }
