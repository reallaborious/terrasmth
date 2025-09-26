run "basic_container_instances_test" {
  command = plan

  variables {
    name                = "test-basic-aci"
    location           = "East US"
    resource_group_name = "test-rg"
    
    containers = [
      {
        name   = "nginx-container"
        image  = "nginx:latest"
        cpu    = 0.5
        memory = 1.5
        
        ports = [
          {
            port     = 80
            protocol = "TCP"
          }
        ]
      }
    ]
    
    exposed_ports = [
      {
        port     = 80
        protocol = "TCP"
      }
    ]
    
    tags = {
      Environment = "Test"
      Purpose     = "BasicContainer"
    }
  }

  assert {
    condition     = azurerm_container_group.aci.name == "test-basic-aci"
    error_message = "Container Group name should match the provided name"
  }

  assert {
    condition     = azurerm_container_group.aci.os_type == "Linux"
    error_message = "OS type should default to Linux"
  }

  assert {
    condition     = azurerm_container_group.aci.ip_address_type == "Public"
    error_message = "IP address type should default to Public"
  }

  assert {
    condition     = azurerm_container_group.aci.restart_policy == "Always"
    error_message = "Restart policy should default to Always"
  }

  assert {
    condition     = length(azurerm_container_group.aci.container) == 1
    error_message = "Should have one container configured"
  }

  assert {
    condition     = azurerm_container_group.aci.container[0].name == "nginx-container"
    error_message = "Container name should match"
  }

  assert {
    condition     = azurerm_container_group.aci.container[0].image == "nginx:latest"
    error_message = "Container image should match"
  }

  assert {
    condition     = azurerm_container_group.aci.tags["Environment"] == "Test"
    error_message = "Environment tag should be set correctly"
  }
}

run "multi_container_instances_test" {
  command = plan

  variables {
    name                = "test-multi-aci"
    location           = "West Europe"
    resource_group_name = "test-rg"
    dns_name_label     = "test-multi-aci"
    
    containers = [
      {
        name   = "web-app"
        image  = "nginx:alpine"
        cpu    = 1.0
        memory = 2.0
        
        ports = [
          {
            port     = 80
            protocol = "TCP"
          }
        ]
        
        environment_variables = {
          ENV = "test"
          APP = "web"
        }
        
        liveness_probe = {
          http_get = {
            path = "/"
            port = 80
          }
          initial_delay_seconds = 30
          period_seconds        = 30
        }
      },
      {
        name   = "sidecar"
        image  = "busybox:latest"
        cpu    = 0.1
        memory = 0.2
        
        commands = ["/bin/sh", "-c", "while true; do sleep 3600; done"]
      }
    ]
    
    exposed_ports = [
      {
        port     = 80
        protocol = "TCP"
      }
    ]
    
    identity = {
      type = "SystemAssigned"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "MultiContainer"
    }
  }

  assert {
    condition     = azurerm_container_group.aci.name == "test-multi-aci"
    error_message = "Container Group name should match the provided name"
  }

  assert {
    condition     = azurerm_container_group.aci.dns_name_label == "test-multi-aci"
    error_message = "DNS name label should match"
  }

  assert {
    condition     = length(azurerm_container_group.aci.container) == 2
    error_message = "Should have two containers configured"
  }

  assert {
    condition     = azurerm_container_group.aci.container[0].name == "web-app"
    error_message = "First container name should match"
  }

  assert {
    condition     = azurerm_container_group.aci.container[1].name == "sidecar"
    error_message = "Second container name should match"
  }

  assert {
    condition     = azurerm_container_group.aci.identity[0].type == "SystemAssigned"
    error_message = "Identity type should be SystemAssigned"
  }

  assert {
    condition     = azurerm_container_group.aci.tags["Purpose"] == "MultiContainer"
    error_message = "Purpose tag should be set correctly"
  }
}

run "container_instances_with_volumes_test" {
  command = plan

  variables {
    name                = "test-volumes-aci"
    location           = "East US"
    resource_group_name = "test-rg"
    
    containers = [
      {
        name   = "app-with-storage"
        image  = "ubuntu:latest"
        cpu    = 0.5
        memory = 1.0
        
        commands = ["/bin/bash", "-c", "while true; do sleep 3600; done"]
        
        volumes = [
          {
            name       = "empty-storage"
            mount_path = "/tmp/empty"
            empty_dir  = true
          },
          {
            name       = "secret-volume"
            mount_path = "/etc/secrets"
            secret = {
              "config.json" = "eyJjb25maWciOiAidGVzdCJ9"  # base64 encoded {"config": "test"}
            }
          }
        ]
      }
    ]
    
    tags = {
      Environment = "Test"
      Purpose     = "VolumeTest"
    }
  }

  assert {
    condition     = azurerm_container_group.aci.name == "test-volumes-aci"
    error_message = "Container Group name should match the provided name"
  }

  assert {
    condition     = length(azurerm_container_group.aci.container[0].volume) == 2
    error_message = "Should have two volumes configured"
  }

  assert {
    condition     = azurerm_container_group.aci.container[0].volume[0].name == "empty-storage"
    error_message = "First volume name should match"
  }

  assert {
    condition     = azurerm_container_group.aci.container[0].volume[1].name == "secret-volume"
    error_message = "Second volume name should match"
  }
}

run "container_instances_private_ip_test" {
  command = plan

  variables {
    name                = "test-private-aci"
    location           = "East US"
    resource_group_name = "test-rg"
    ip_address_type    = "Private"
    
    containers = [
      {
        name   = "private-container"
        image  = "nginx:latest"
        cpu    = 0.5
        memory = 1.0
      }
    ]
    
    subnet_ids = ["/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet"]
    
    tags = {
      Environment = "Test"
      Purpose     = "PrivateNetwork"
    }
  }

  assert {
    condition     = azurerm_container_group.aci.name == "test-private-aci"
    error_message = "Container Group name should match the provided name"
  }

  assert {
    condition     = azurerm_container_group.aci.ip_address_type == "Private"
    error_message = "IP address type should be Private"
  }

  assert {
    condition     = length(azurerm_container_group.aci.subnet_ids) == 1
    error_message = "Should have one subnet configured"
  }
}

run "container_instances_name_validation_test" {
  command = plan

  variables {
    name                = "invalid_name_with_underscores"
    location           = "East US"
    resource_group_name = "test-rg"
    
    containers = [
      {
        name   = "test-container"
        image  = "nginx:latest"
        cpu    = 0.5
        memory = 1.0
      }
    ]
  }

  expect_failures = [
    var.name
  ]
}

run "container_instances_os_type_validation_test" {
  command = plan

  variables {
    name                = "test-validation-aci"
    location           = "East US"
    resource_group_name = "test-rg"
    os_type            = "InvalidOS"
    
    containers = [
      {
        name   = "test-container"
        image  = "nginx:latest"
        cpu    = 0.5
        memory = 1.0
      }
    ]
  }

  expect_failures = [
    var.os_type
  ]
}

run "container_instances_empty_containers_validation_test" {
  command = plan

  variables {
    name                = "test-empty-aci"
    location           = "East US"
    resource_group_name = "test-rg"
    
    containers = []
  }

  expect_failures = [
    var.containers
  ]
}