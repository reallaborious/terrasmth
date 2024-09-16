run "test" {
    command = plan
    module {
        # there's no need create any file implimenting the module, variables can be set in "variables"
        # source = "./tests/setup" # first i tested it with main.tf in this dir
        source = "./" #it's modules root, the parent of "tests" dir. it's supposed that 'terraform test' is run there.
    }
    variables {
        rg_name = "test"
        subscription_id = "00000000-0000-0000-0000-000000000000" #it will use default from az account list
        location = "East US"
    }
    assert {
        # condition = run.test.name == "test"
        condition = azurerm_resource_group.rg.name == "test"
        error_message = "incorrect name"
    }
}