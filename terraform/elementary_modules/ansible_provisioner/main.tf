locals {
  inventory_path = abspath(local_file.ansible_inventory.filename)

  generated_vars_path = length(local_file.ansible_vars) > 0 ? abspath(local_file.ansible_vars[0].filename) : null

  extra_vars_files = var.extra_vars_files != null ? var.extra_vars_files : []

  extra_vars_args = concat(
    [for f in local.extra_vars_files : "--extra-vars @${abspath(f)}"],
    local.generated_vars_path != null ? ["--extra-vars @${local.generated_vars_path}"] : []
  )

  become_args = var.ansible_become ? (
    var.ansible_become_user != null && var.ansible_become_user != "" ? ["--become", "--become-user=${var.ansible_become_user}"] : ["--become"]
  ) : []

  tags_args = length(var.ansible_tags) > 0 ? ["--tags", join(",", var.ansible_tags)] : []

  skip_tags_args = length(var.ansible_skip_tags) > 0 ? ["--skip-tags", join(",", var.ansible_skip_tags)] : []

  limit_args = var.ansible_limit != null && var.ansible_limit != "" ? ["--limit", var.ansible_limit] : []

  verbosity_flag = var.ansible_verbosity > 0 ? format("-%s", join("", [for i in range(var.ansible_verbosity) : "v"])) : ""

  # For change detection and re-run triggers
  args_hash = sha256(jsonencode({
    extra_vars_files   = var.extra_vars_files
    extra_vars         = var.extra_vars
    ansible_become     = var.ansible_become
    ansible_become_user= var.ansible_become_user
    ansible_tags       = var.ansible_tags
    ansible_skip_tags  = var.ansible_skip_tags
    ansible_limit      = var.ansible_limit
    ansible_verbosity  = var.ansible_verbosity
    ansible_extra_args = var.ansible_extra_args
    inventory_group    = var.inventory_group
  }))
}

# Generate inventory file for Ansible
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/generated_inventory.ini"
  content = templatefile("${path.module}/inventory.tpl", {
    hosts = var.target_hosts
    group = var.inventory_group
  })

  provisioner "local-exec" {
    command = "chmod 644 ${self.filename}"
  }
}

# Optionally generate extra vars file for Ansible from provided map
resource "local_file" "ansible_vars" {
  count    = var.extra_vars != null && length(keys(var.extra_vars)) > 0 ? 1 : 0
  filename = "${path.module}/extra_vars.json"
  content  = jsonencode(var.extra_vars)

  provisioner "local-exec" {
    command = "chmod 644 ${self.filename}"
  }
}

# Wait for SSH to be ready
resource "null_resource" "wait_for_ssh" {
  count = length(var.target_hosts)

  provisioner "local-exec" {
    command = <<-EOT
      timeout 300 bash -c '
        while ! nc -z ${var.target_hosts[count.index].ansible_host} 22; do
          echo "Waiting for SSH on ${var.target_hosts[count.index].ansible_host}:22..."
          sleep 5
        done
        echo "SSH is ready on ${var.target_hosts[count.index].ansible_host}:22"
      '
    EOT
  }

  triggers = {
    host_ip = var.target_hosts[count.index].ansible_host
  }
}

# Run Ansible playbook
resource "null_resource" "ansible_provisioner" {
  depends_on = [
    local_file.ansible_inventory,
    local_file.ansible_vars,
    null_resource.wait_for_ssh
  ]

  provisioner "local-exec" {
    command = <<-EOT
      # Test connectivity first
      ansible all -i ${local.inventory_path} -m ping --timeout=30
      
      # Run the playbook
      ansible-playbook \
        -i ${local.inventory_path} \
        ${local.verbosity_flag} \
        ${join(" ", concat(local.extra_vars_args, local.become_args, local.tags_args, local.skip_tags_args, local.limit_args, var.ansible_extra_args))} \
        --timeout=${var.ansible_timeout} \
        ${var.playbook_path}
    EOT
    
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  triggers = {
    playbook_content   = filesha256(var.playbook_path)
    inventory_content  = local_file.ansible_inventory.content
    vars_content       = length(local_file.ansible_vars) > 0 ? local_file.ansible_vars[0].content : ""
    hosts_changed      = sha256(jsonencode(var.target_hosts))
    args_changed       = local.args_hash
  }
}