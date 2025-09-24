variable "rg_name" {
    type = string
    description = "Azure resource group name"
}
variable "subscription_id" {
  type = string
  description = "Azure subscription ID where the resource group should be created"
  validation {
    condition = match(regex, subscription_id)
    error_message = "Subscription ID must be a valid UUID format"
  }
}
variable "location" {
    type = string
    description = "Azure resource group location"
}
