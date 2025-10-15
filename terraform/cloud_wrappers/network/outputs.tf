output "network_id" {
  value = var.cloud == "azure" ? module.azure[0].vnet_id : module.aws[0].vpc_id
}

output "subnet_ids" {
  value = var.cloud == "azure" ? module.azure[0].subnet_ids : module.aws[0].subnet_ids
}
