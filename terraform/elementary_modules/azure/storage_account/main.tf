resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind            = var.account_kind
  
  min_tls_version                = var.min_tls_version
  enable_https_traffic_only      = var.enable_https_traffic_only
  public_network_access_enabled  = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  
  dynamic "blob_properties" {
    for_each = var.blob_properties != null ? [var.blob_properties] : []
    content {
      versioning_enabled       = blob_properties.value.versioning_enabled
      change_feed_enabled      = blob_properties.value.change_feed_enabled
      default_service_version  = blob_properties.value.default_service_version
      last_access_time_enabled = blob_properties.value.last_access_time_enabled
      
      dynamic "cors_rule" {
        for_each = blob_properties.value.cors_rule != null ? blob_properties.value.cors_rule : []
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
      
      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }
    }
  }
  
  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
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

# File shares for Azure Files
resource "azurerm_storage_share" "file_share" {
  for_each = {
    for share in var.file_shares : share.name => share
  }
  
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota
  enabled_protocol     = each.value.enabled_protocol
  access_tier          = each.value.access_tier
}