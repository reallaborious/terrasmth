variable "cloud" { type = string }
# Azure inputs
variable "azure_location" { type = string, default = null }
variable "azure_rg_name" { type = string, default = null }
variable "address_space" { type = list(string) }
variable "subnet_names" { type = list(string) }
variable "subnet_prefixes" { type = list(string) }

# AWS inputs
variable "aws_region" { type = string, default = null }
variable "name" { type = string }

variable "tags" { type = map(string) default = {} }
