variable "cloud" { type = string, default = "azure" }
variable "location" { type = string, default = "westus" }
variable "rg_name" { type = string, default = "" }
variable "vm_name" { type = string, default = "ollama-vm" }
variable "network_interface_id" { type = string }
variable "admin_username" { type = string, default = "terrasmth" }
variable "ssh_public_key" { type = string, default = "" }
variable "vm_size" { type = string, default = "Standard_B4ms" }
variable "instance_type" { type = string, default = "t3.micro" }
variable "tags" { type = map(string), default = {} }
