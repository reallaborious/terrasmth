variable "cloud" { type = string }

# Azure
variable "azure_location" { type = string, default = null }
variable "azure_rg_name" { type = string, default = null }
variable "admin_username" { type = string }
variable "ssh_public_key" { type = string, default = null }
variable "vm_size" { type = string, default = "Standard_B4ms" }
variable "network_interface_ids" { type = list(string), default = [] }

# AWS
variable "aws_region" { type = string, default = null }
variable "instance_type" { type = string, default = "t3.large" }
variable "ami" { type = string, default = null }
variable "subnet_id" { type = string, default = null }
variable "security_group_ids" { type = list(string), default = [] }
variable "associate_public_ip_address" { type = bool, default = true }
variable "key_name" { type = string, default = null }

variable "name" { type = string }
variable "tags" { type = map(string) default = {} }
