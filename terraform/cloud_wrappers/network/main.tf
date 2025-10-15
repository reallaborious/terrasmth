terraform {
  required_version = ">= 1.0"
}

locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure" {
  count   = local.use_azure ? 1 : 0
  source  = "../../elementary_modules/azure/virtual_network"
  vnet_name       = var.name
  location        = var.azure_location
  rg_name         = var.azure_rg_name
  address_space   = var.address_space
  subnet_names    = var.subnet_names
  subnet_prefixes = var.subnet_prefixes
  tags            = var.tags
}

module "aws" {
  count       = local.use_aws ? 1 : 0
  source      = "../../elementary_modules/aws/vpc"
  name        = var.name
  aws_region  = var.aws_region
  vpc_cidr    = var.address_space[0]
  subnet_cidrs = var.subnet_prefixes
  tags        = var.tags
}
