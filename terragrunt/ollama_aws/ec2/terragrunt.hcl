include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "network_interface" {
  config_path = "../network_interface"
}

terraform {
  source = "../../terraform/elementary_modules/aws/ec2"
}

locals {
  root      = read_terragrunt_config(find_in_parent_folders("variables_ollama.hcl"))
  ssh_user  = try(local.root.locals.ssh_user, get_env("TF_SSH_USER", "ollama"))
}

inputs = {
  region               = get_env("AWS_REGION", "us-east-1")
  name                 = "ollama-vm"
  instance_type        = get_env("TF_INSTANCE_TYPE", "t3.micro")
  network_interface_id = dependency.network_interface.outputs.network_interface_id
  ssh_public_key       = get_env("TF_SSH_PUBLIC_KEY", "")
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "virtual-machine"
  }
}
