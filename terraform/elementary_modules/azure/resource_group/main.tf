resource "azurerm_resource_group" "rg" {
    name     = var.rg_name
    location = var.location
    timeouts {
      create = var.timeout_create
      update = var.timeout_update
      delete = var.timeout_delete
      read = var.timeout_read
    }
}
