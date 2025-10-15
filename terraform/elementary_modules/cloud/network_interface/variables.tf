variable "cloud" { type = string, default = "azure" }
variable "location" { type = string, default = "westus" }
variable "rg_name" { type = string, default = "" }
variable "subnet_id" { type = string, default = "" }
variable "public_ip_id" { type = string, default = "" }
variable "security_group_id" { type = string, default = "" }
variable "tags" { type = map(string), default = {} }
