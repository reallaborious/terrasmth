output "security_group_id" {
  value = var.cloud == "azure" ? module.azure[0].network_security_group_id : module.aws[0].security_group_id
}
