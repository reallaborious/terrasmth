# AWS-only Ollama stack orchestrator

include {
  path = find_in_parent_folders("variables_ollama.hcl")
}

dependencies {
  paths = [
    "./network",
    "./security_group",
    "./public_ip",
    "./network_interface",
    "./ec2",
    "./provisioning"
  ]
}
