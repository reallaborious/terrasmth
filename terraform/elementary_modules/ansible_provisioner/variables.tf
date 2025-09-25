variable "target_hosts" {
  description = "List of target hosts for Ansible provisioning"
  type = list(object({
    name                          = string
    ansible_host                  = string
    ansible_user                  = string
    ansible_ssh_private_key_file  = string
  }))
}

variable "playbook_path" {
  description = "Path to the Ansible playbook"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "ansible_timeout" {
  description = "Timeout for Ansible playbook execution (in seconds)"
  type        = number
  default     = 1800
}