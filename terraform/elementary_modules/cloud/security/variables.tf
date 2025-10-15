variable "cloud" {
  type        = string
  default     = "azure"
  validation {
    condition     = contains(["azure", "aws"], var.cloud)
    error_message = "cloud must be 'azure' or 'aws'"
  }
}

variable "location" { type = string, default = "westus" }
variable "rg_name"  { type = string, default = "" }
variable "vpc_id"   { type = string, default = "" }

variable "tags" {
  type    = map(string)
  default = {}
}
