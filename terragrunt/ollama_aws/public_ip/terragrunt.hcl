include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

terraform {
  source = "../../terraform/elementary_modules/aws/eip"
}

inputs = {
  region = get_env("AWS_REGION", "us-east-1")
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "eip"
  }
}
