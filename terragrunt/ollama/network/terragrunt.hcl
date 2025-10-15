include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

locals {
  root  = read_terragrunt_config(find_in_parent_folders("variables_ollama.hcl"))
  cloud = try(local.root.locals.cloud, get_env("CLOUD", get_env("AWS_REGION", "") != "" ? "aws" : "azure"))
  azure_inputs_yaml = <<-EOT
    vnet_name: "ollama-vnet"
    location: "${dependency.rg.outputs.location}"
    rg_name: "${dependency.rg.outputs.resource_group_name}"
    address_space:
      - "10.0.0.0/16"
    subnet_names:
      - "ollama-subnet"
    subnet_prefixes:
      - "10.0.1.0/24"
    tags:
      Environment: "development"
      Project: "ollama"
      Component: "virtual-network"
  EOT
  aws_inputs_yaml = <<-EOT
    region: "${dependency.rg.outputs.location}"
    name: "ollama-vpc"
    cidr_block: "10.0.0.0/16"
    subnet_prefixes:
      - "10.0.1.0/24"
    subnet_names:
      - "ollama-subnet"
    tags:
      Environment: "development"
      Project: "ollama"
      Component: "vpc"
  EOT
}

dependency "rg" {
  config_path = "../resource_group"
  
  mock_outputs = {
    resource_group_name = "mock-rg"
    location           = "eastus"
  }
}



terraform {
  source = local.cloud == "azure" ? "../../../terraform/elementary_modules/azure/virtual_network" : "../../../terraform/elementary_modules/aws/vpc"
}

locals {
  azure_inputs_yaml = <<-EOT
    vnet_name: "ollama-vnet"
    location: "${dependency.rg.outputs.location}"
    rg_name: "${dependency.rg.outputs.resource_group_name}"
    address_space:
      - "10.0.0.0/16"
    subnet_names:
      - "ollama-subnet"
    subnet_prefixes:
      - "10.0.1.0/24"
    tags:
      Environment: "development"
      Project: "ollama"
      Component: "virtual-network"
  EOT

  aws_inputs_yaml = <<-EOT
    region: "${dependency.rg.outputs.location}"
    name: "ollama-vpc"
    cidr_block: "10.0.0.0/16"
    subnet_prefixes:
      - "10.0.1.0/24"
    subnet_names:
      - "ollama-subnet"
    tags:
      Environment: "development"
      Project: "ollama"
      Component: "vpc"
  EOT
}

inputs = yamldecode(local.cloud == "azure" ? local.azure_inputs_yaml : local.aws_inputs_yaml)