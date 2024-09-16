run "test" {
    module {
        # there's no need create any file implimenting the module, variables can be set in "variables"
        # source = "./tests/setup"
        source = "./" #it's modules root, the parent of "tests" dir. it's supposed that 'terraform test' is ran there.
    }
    variables {
        rg_name = "test"
        # subscription_id = "4ad508ec-d0f2-46ba-98de-be8faeef5668"
        subscription_id = "00000000-0000-0000-0000-000000000000" #fake subscription
        location = "East US" # haven't tested it with some nonsese, interesting...
    }
# }

# run "name_test" {
    # command = apply
    assert {
        # condition = run.test.name == "test"
        condition = azurerm_resource_group.rg.name == "test"
        error_message = "incorrect name"
    }
}