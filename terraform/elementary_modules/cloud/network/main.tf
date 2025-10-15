locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure_vnet" {
  source = "../../azure/virtual_network"
  count  = local.use_azure ? 1 : 0

  vnet_name       = "ollama-vnet"
  location        = var.location
  rg_name         = var.rg_name
  address_space   = var.address_space
  subnet_names    = var.subnet_names
  subnet_prefixes = var.subnet_prefixes
  tags            = var.tags
}

module "aws_vpc" {
  source = "../../aws/vpc"
  count  = local.use_aws ? 1 : 0

  region          = var.location
  name            = "ollama-vpc"
  cidr_block      = var.address_space[0]
  subnet_prefixes = var.subnet_prefixes
  subnet_names    = var.subnet_names
  tags            = var.tags
}

output "subnet_ids" {
  value = local.use_azure ? module.azure_vnet[0].subnet_ids : (local.use_aws ? module.aws_vpc[0].subnet_ids : [])
}
