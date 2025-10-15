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
  source = local.cloud == "azure" ? "../../../terraform/elementary_modules/azure/network_security_group" : "../../../terraform/elementary_modules/aws/security_group"
}

inputs = yamldecode(local.cloud == "azure" ? <<-EOT
  network_security_group_name: "ollama-vm-nsg"
  resource_group_name: "${dependency.rg.outputs.resource_group_name}"
  security_rules: []
  tags:
    Environment: "development"
    Project: "ollama"
    Component: "network-security-group"
EOT
:
<<-EOT
  region: "${dependency.rg.outputs.location}"
  name: "ollama-sg"
  vpc_id: ""
  ingress: []
  tags:
    Environment: "development"
    Project: "ollama"
    Component: "security-group"
EOT
)