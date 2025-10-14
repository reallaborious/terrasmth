output "ansible_inventory_path" {
  description = "Path to the generated Ansible inventory file"
  value       = local_file.ansible_inventory.filename
}

output "ansible_vars_path" {
  description = "Path to the generated Ansible extra vars file (if any)"
  value       = length(local_file.ansible_vars) > 0 ? local_file.ansible_vars[0].filename : null
}

output "provisioning_status" {
  description = "Status of the Ansible provisioning"
  value       = "completed"
  depends_on  = [null_resource.ansible_provisioner]
}

output "target_hosts" {
  description = "List of provisioned hosts"
  value       = var.target_hosts
}