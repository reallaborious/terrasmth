include {
  path = find_in_parent_folders("variables_hunyuan3d.hcl")
}

terraform {
  source = "../../../terraform/elementary_modules/azure/storage_account"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("variables_hunyuan3d.hcl"))
}

dependency "resource_group" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "hunyuan3d-2gp-rg"
    location           = "eastus"
  }
}

dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    subnet_ids = ["mock-subnet-id"]
  }
}

inputs = {
  name                = "${replace(local.config.locals.project_name, "-", "")}storage"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location           = local.config.locals.location
  
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind            = "StorageV2"
  
  min_tls_version                = "TLS1_2"
  enable_https_traffic_only      = true
  public_network_access_enabled  = true
  allow_nested_items_to_be_public = false
  
  blob_properties = {
    versioning_enabled       = true
    change_feed_enabled      = false
    last_access_time_enabled = false
    delete_retention_policy = {
      days = 30
    }
  }
  
  network_rules = {
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [dependency.network.outputs.subnet_ids[0]]
  }
  
  tags = merge(local.config.locals.common_tags, {
    Component = "Storage"
    Purpose   = "ModelCache"
  })
}