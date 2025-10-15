output "name" {
  value = var.cloud == "azure" ? module.azure[0].name : module.aws[0].name
}

output "public_ip_address" {
  value = var.cloud == "azure" ? module.azure[0].public_ip_address : module.aws[0].public_ip
}

output "private_ip_address" {
  value = var.cloud == "azure" ? module.azure[0].private_ip_address : module.aws[0].private_ip
}
