variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "List of subnet CIDRs"
}

variable "name" {
  type        = string
  description = "Name prefix"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
