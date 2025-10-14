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

variable "ansible_timeout" {
  description = "Timeout for Ansible playbook execution (in seconds)"
  type        = number
  default     = 1800
}

variable "inventory_group" {
  description = "Inventory group name to use in generated inventory (default 'all')"
  type        = string
  default     = ""
}

variable "extra_vars" {
  description = "Extra variables to pass to Ansible (rendered to a temp JSON file). Accepts any type including nested structures."
  type        = any
  default     = {}
}

variable "extra_vars_files" {
  description = "List of extra vars files (YAML/JSON) to pass to Ansible with --extra-vars @file"
  type        = list(string)
  default     = []
}

variable "ansible_become" {
  description = "Use privilege escalation (become)"
  type        = bool
  default     = true
}

variable "ansible_become_user" {
  description = "User to become when using privilege escalation"
  type        = string
  default     = ""
}

variable "ansible_tags" {
  description = "List of tags to include"
  type        = list(string)
  default     = []
}

variable "ansible_skip_tags" {
  description = "List of tags to skip"
  type        = list(string)
  default     = []
}

variable "ansible_limit" {
  description = "Limit which hosts to target (Ansible --limit)"
  type        = string
  default     = ""
}

variable "ansible_verbosity" {
  description = "Verbosity level (0-4) to pass as -v flags"
  type        = number
  default     = 1
}

variable "ansible_extra_args" {
  description = "Additional raw arguments to append to ansible-playbook"
  type        = list(string)
  default     = []
}