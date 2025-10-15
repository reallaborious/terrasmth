locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure_vm" {
  source = "../terraform/elementary_modules/azure/vps-linux"
  count  = local.use_azure ? 1 : 0

  vm_name               = var.vm_name
  resource_group_name   = var.rg_name
  location              = var.location
  network_interface_ids = [var.network_interface_id]
  admin_username        = var.admin_username
  ssh_public_key        = trimspace(var.ssh_public_key) != "" ? var.ssh_public_key : null
  vm_size               = var.vm_size
  tags                  = var.tags
}

module "aws_ec2" {
  source = "../terraform/elementary_modules/aws/ec2"
  count  = local.use_aws ? 1 : 0

  aws_region                = var.location
  instance_name             = var.vm_name
  instance_type             = var.instance_type
  subnet_id                 = null
  security_group_ids        = []
  associate_public_ip_address = true
  ami                       = null
  key_name                  = null
  tags                      = var.tags
}

output "name" {
  value = local.use_azure ? module.azure_vm[0].name : (local.use_aws ? module.aws_ec2[0].name : null)
}

output "public_ip_address" {
  value = local.use_azure ? module.azure_vm[0].public_ip_address : (local.use_aws ? module.aws_ec2[0].public_ip : null)
}

output "private_ip_address" {
  value = local.use_azure ? module.azure_vm[0].private_ip_address : (local.use_aws ? module.aws_ec2[0].private_ip : null)
}
