## Timeouts variables
variable "timeout_create" {
  type        = string
  default     = "20m"
  description = "Used when creating the Storage Account."
}

variable "timeout_update" {
  type        = string
  default     = "20m"
  description = "Used when updating the Storage Account."
}

variable "timeout_delete" {
  type        = string
  default     = "20m"
  description = "Used when deleting the Storage Account."
}

variable "timeout_read" {
  type        = string
  default     = "5m"
  description = "Used when retrieving the Storage Account."
}