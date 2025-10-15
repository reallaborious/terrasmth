include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "network" {
  config_path = "../network"
}

dependency "public_ip" {
  config_path = "../public_ip"
}

dependency "security_group" {
  config_path = "../security_group"
}

terraform {
  source = "../../terraform/elementary_modules/aws/eni"
}

inputs = {
  region                  = get_env("AWS_REGION", "us-east-1")
  subnet_id               = dependency.network.outputs.subnet_ids[0]
  public_ip_allocation_id = null
  security_group_ids      = []
}
