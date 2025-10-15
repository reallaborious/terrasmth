terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# No-op resource. We just return region and tags as outputs for consistency.
locals {
  scope_name = var.name
}
