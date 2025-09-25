## Timeouts variables
variable "timeout_create" {
    type = string
    default = "10m"
    description = "Used when creating the Resource Group."
}
variable "timeout_update" {
    type = string
    default = "10m"
    description = "Used when updating the Resource Group."
}
variable "timeout_delete" {
    type = string
    default = "10m"
    description = "Used when deleting the Resource Group."
}
variable "timeout_read" {
    type = string
    default = "5m"
    description = "Used when retrieving the Resource Group."
}
