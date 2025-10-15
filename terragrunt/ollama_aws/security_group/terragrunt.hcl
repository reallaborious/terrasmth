include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../terraform/elementary_modules/aws/security_group"
}

inputs = {
  region = get_env("AWS_REGION", "us-east-1")
  name   = "ollama-sg"
  vpc_id = null
  ingress = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "SSH" },
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "HTTP" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "HTTPS" }
  ]
  tags = {
    Environment = "development"
    Project     = "ollama"
    Component   = "security-group"
  }
}
