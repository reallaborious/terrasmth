## Timeouts variables
variable "timeout_create" {
  type        = string
  default     = "30m"
  description = "Used when creating the Container Registry."
}

variable "timeout_update" {
  type        = string
  default     = "30m"
  description = "Used when updating the Container Registry."
}

variable "timeout_delete" {
  type        = string
  default     = "30m"
  description = "Used when deleting the Container Registry."
}

variable "timeout_read" {
  type        = string
  default     = "5m"
  description = "Used when retrieving the Container Registry."
}