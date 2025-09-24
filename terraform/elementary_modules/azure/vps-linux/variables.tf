variable "subscription_id" {
  type = string
  description = "Azure subscription ID used to deploy the Linux VM"
  validation {
    condition = match(regex, subscription_id)
    error_message = "Subscription ID must be a valid UUID format"
  }
}
