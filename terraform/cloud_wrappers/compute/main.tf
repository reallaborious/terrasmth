terraform {
  required_version = ">= 1.0"
}

locals {
  use_azure = var.cloud == "azure"
  use_aws   = var.cloud == "aws"
}

module "azure" {
  count   = local.use_azure ? 1 : 0
  source  = "../../elementary_modules/azure/vps-linux"
  vm_name               = var.name
  resource_group_name   = var.azure_rg_name
  location              = var.azure_location
  network_interface_ids = var.network_interface_ids
  admin_username        = var.admin_username
  ssh_public_key        = var.ssh_public_key
  vm_size               = var.vm_size
  tags                  = var.tags
}

module "aws" {
  count      = local.use_aws ? 1 : 0
  source     = "../../elementary_modules/aws/ec2"
  instance_name             = var.name
  aws_region                = var.aws_region
  instance_type             = var.instance_type
  ami                       = coalesce(var.ami, "ami-0e472ba40eb589f49")
  subnet_id                 = var.subnet_id
  security_group_ids        = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  key_name                  = var.key_name
  tags                      = var.tags
}
