variable "rg_name" {
    type = string
    description = "Azure resource group name"
}

variable "rg_location" {
    type = string
    description = "Azure resource group location"
}

## Timeouts variables
variable "timeout_create" {
    type = number
    default = 10
    description = "Used when creating the Resource Group."
}
variable "timeout_update" {
    type = number
    default = 10
    description = "Used when updating the Resource Group."
}
variable "timeout_delete" {
    type = number
    default = 10
    description = "Used when deleting the Resource Group."
}
variable "timeout_read" {
    type = number
    default = 5
    description = "Used when retrieving the Resource Group."
}
