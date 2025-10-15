include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

locals {
  root  = read_terragrunt_config(find_in_parent_folders("variables_ollama.hcl"))
  cloud = try(local.root.locals.cloud, get_env("CLOUD", get_env("AWS_REGION", "") != "" ? "aws" : "azure"))
}

dependency "rg" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "mock-rg"
    location           = "eastus"
  }
}



terraform {
  source = local.cloud == "azure" ? "../../../terraform/elementary_modules/azure/public_ip" : "../../../terraform/elementary_modules/aws/eip"
}

locals {
  azure_inputs_yaml = <<-EOT
    public_ip_name: "ollama-vm-pip"
    resource_group_name: "${dependency.rg.outputs.resource_group_name}"
    location: "${dependency.rg.outputs.location}"
    allocation_method: "Static"
    sku: "Standard"
    tags:
      Environment: "development"
      Project: "ollama"
      Component: "public-ip"
  EOT

  aws_inputs_yaml = <<-EOT
    region: "${dependency.rg.outputs.location}"
    tags:
      Environment: "development"
      Project: "ollama"
      Component: "eip"
  EOT
}

inputs = yamldecode(local.cloud == "azure" ? local.azure_inputs_yaml : local.aws_inputs_yaml)