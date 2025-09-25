variable "rg_name" {
    type = string
    description = "Azure resource group name"
}
variable "subscription_id" {
  type = string
  description = "Azure subscription ID where the resource group should be created"
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "subscription_id must be a valid UUID format (36 chars, hex + dashes)."
  }
}
variable "location" {
    type = string
    description = "Azure resource group location"
}
