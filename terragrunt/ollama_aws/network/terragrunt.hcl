include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

terraform {
  source = "../../terraform/elementary_modules/aws/vpc"
}

inputs = {
  region          = get_env("AWS_REGION", "us-east-1")
  name            = "ollama-vpc"
  cidr_block      = "10.0.0.0/16"
  subnet_prefixes = ["10.0.1.0/24"]
  subnet_names    = ["ollama-subnet"]
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "vpc"
  }
}
