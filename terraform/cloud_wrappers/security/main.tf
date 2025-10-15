terraform {
  required_version = ">= 1.0"
}

locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure" {
  count   = local.use_azure ? 1 : 0
  source  = "../../elementary_modules/azure/network_security_group"
  network_security_group_name = var.name
  location                    = var.azure_location
  resource_group_name         = var.azure_rg_name
  security_rules              = var.security_rules
  tags                        = var.tags
}

module "aws" {
  count      = local.use_aws ? 1 : 0
  source     = "../../elementary_modules/aws/security_group"
  name       = var.name
  vpc_id     = var.vpc_id
  aws_region = var.aws_region
  tags       = var.tags
  ingress_rules = [
    for r in var.security_rules : {
      from_port   = tonumber(r.destination_port_range)
      to_port     = tonumber(r.destination_port_range)
      protocol    = lower(r.protocol) == "tcp" ? "tcp" : (lower(r.protocol) == "udp" ? "udp" : "-1")
      cidr_blocks = [r.source_address_prefix]
    }
  ]
}
