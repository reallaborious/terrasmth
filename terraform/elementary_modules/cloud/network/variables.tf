variable "cloud" {
  description = "Target cloud: azure | aws"
  type        = string
  default     = "azure"
  validation {
    condition     = contains(["azure", "aws"], var.cloud)
    error_message = "cloud must be 'azure' or 'aws'"
  }
}

# Universal inputs
variable "location" {
  type        = string
  description = "Region/location"
  default     = "westus"
}

variable "rg_name" {
  type        = string
  description = "Azure resource group name (ignored on AWS)"
  default     = ""
}

variable "address_space" {
  type        = list(string)
  description = "Address space for VNet/VPC"
  default     = ["10.0.0.0/16"]
}

variable "subnet_names" {
  type        = list(string)
  default     = ["subnet"]
}

variable "subnet_prefixes" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  type        = map(string)
  default     = {}
}
