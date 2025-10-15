locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure_pip" {
  source = "../../azure/public_ip"
  count  = local.use_azure ? 1 : 0

  public_ip_name      = "ollama-vm-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

module "aws_eip" {
  source = "../../aws/eip"
  count  = local.use_aws ? 1 : 0

  aws_region = var.location
  name       = "ollama-pip"
  tags       = var.tags
}

output "public_ip_id" {
  value = local.use_azure ? module.azure_pip[0].public_ip_id : (local.use_aws ? module.aws_eip[0].eip_id : null)
}

output "public_ip_address" {
  value = local.use_azure ? module.azure_pip[0].public_ip_address : (local.use_aws ? module.aws_eip[0].public_ip : null)
}
