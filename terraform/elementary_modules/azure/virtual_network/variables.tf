variable "vnet_name" {
    type = string
    description = "Azure Virtual Network name"
}
variable "subscription_id" {
  type = string
  description = "Subscription name in what a RG should be created"
}
variable "location" {
    type = string
    description = "Azure resource group location"
}
variable "rg_name" {
    type = string
    description = "Azure resource group name"
}
variable "address_space" {
    type = list
    description = "Adress space"
}