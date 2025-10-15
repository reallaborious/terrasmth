variable "cloud" { type = string, default = "azure" }
variable "location" { type = string, default = "westus" }
variable "rg_name" { type = string, default = "" }
variable "tags" { type = map(string), default = {} }
