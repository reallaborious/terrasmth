override_resource {
  target = azurerm_resource_group.rg
}

run "test" {
    command = plan
    module {
        # there's no need create any file implimenting the module, variables can be set in "variables"
        # source = "./tests/setup" # first i tested it with main.tf in this dir
        source = "./" #it's modules root, the parent of "tests" dir. it's supposed that 'terraform test' is run there.
    }
    variables {
        vnet_name = "test"
        subscription_id = "00000000-0000-0000-0000-000000000000" #it will use default from az account list
        location = "East US"
        rg_name = azurerm_resource_group.rg.name
        address_space = ["10.0.0.0/8"]
    }
    assert {
        # condition = run.test.name == "test"
        condition = azurerm_virtual_network.vnet.name == "test"
        error_message = "incorrect name"
    }
}