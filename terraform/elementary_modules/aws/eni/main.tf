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

resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids
  tags            = merge(var.tags, { Name = var.name })
}
