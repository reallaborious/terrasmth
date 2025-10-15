locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure_nic" {
  source = "../terraform/elementary_modules/azure/network_interface"
  count  = local.use_azure ? 1 : 0

  network_interface_name = "ollama-vm-nic"
  location               = var.location
  resource_group_name    = var.rg_name
  ip_configurations = [
    {
      name                          = "internal"
      subnet_id                     = var.subnet_id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = var.public_ip_id
    }
  ]
  tags = var.tags
}

module "aws_eni" {
  source = "../terraform/elementary_modules/aws/eni"
  count  = local.use_aws ? 1 : 0

  aws_region         = var.location
  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_id != "" ? [var.security_group_id] : []
  # In AWS, EIP is associated to instance or ENI separately; ENI module doesn't accept EIP id here
}

output "network_interface_id" {
  value = local.use_azure ? module.azure_nic[0].network_interface_id : (local.use_aws ? module.aws_eni[0].eni_id : null)
}
