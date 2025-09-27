resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  
  dynamic "georeplications" {
    for_each = var.georeplications
    content {
      location                  = georeplications.value.location
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      tags                      = georeplications.value.tags
    }
  }
  
  dynamic "network_rule_set" {
    for_each = var.network_rule_set != null ? [var.network_rule_set] : []
    content {
      default_action = network_rule_set.value.default_action
      
      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rule != null ? network_rule_set.value.ip_rule : []
        content {
          action   = ip_rule.value.action
          ip_range = ip_rule.value.ip_range
        }
      }
      
      dynamic "virtual_network" {
        for_each = network_rule_set.value.virtual_network != null ? network_rule_set.value.virtual_network : []
        content {
          action    = virtual_network.value.action
          subnet_id = virtual_network.value.subnet_id
        }
      }
    }
  }
  
  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? [var.retention_policy] : []
    content {
      days    = retention_policy.value.days
      enabled = retention_policy.value.enabled
    }
  }
  
  dynamic "trust_policy" {
    for_each = var.trust_policy != null ? [var.trust_policy] : []
    content {
      enabled = trust_policy.value.enabled
    }
  }
  
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  
  dynamic "encryption" {
    for_each = var.encryption != null ? [var.encryption] : []
    content {
      enabled            = encryption.value.enabled
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }
  
  tags = var.tags
  
  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
    read   = var.timeout_read
  }
}

# ACR Tasks will be created separately or via Azure CLI
# This keeps the Terraform configuration simpler and more reliable