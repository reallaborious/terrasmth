run "test_virtual_network" {
    command = plan
    module {
        source = "./" # Root directory where the module is implemented
    }
    variables {
        vnet_name        = "test-vnet"
        location         = "East US"
        rg_name          = "test-rg"
        address_space    = ["10.0.0.0/8"]
        subnet_names     = ["subnet1", "subnet2"]
        subnet_prefixes  = ["10.0.1.0/24", "10.0.2.0/24"]
    }
    assert {
        condition     = azurerm_virtual_network.vnet.name == "test-vnet"
        error_message = "Virtual network name is incorrect."
    }
}
