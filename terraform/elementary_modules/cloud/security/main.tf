locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure_nsg" {
  source = "../../azure/network_security_group"
  count  = local.use_azure ? 1 : 0

  network_security_group_name = "ollama-vm-nsg"
  location                    = var.location
  resource_group_name         = var.rg_name
  security_rules              = []
  tags                        = var.tags
}

module "aws_sg" {
  source = "../../aws/security_group"
  count  = local.use_aws ? 1 : 0

  region  = var.location
  name    = "ollama-sg"
  vpc_id  = var.vpc_id
  ingress = []
  tags    = var.tags
}

output "security_group_id" {
  value = local.use_azure ? module.azure_nsg[0].network_security_group_id : (local.use_aws ? module.aws_sg[0].security_group_id : null)
}
