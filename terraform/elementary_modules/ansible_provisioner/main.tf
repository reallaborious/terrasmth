# Generate inventory file for Ansible
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/generated_inventory.ini"
  content = templatefile("${path.module}/inventory.tpl", {
    hosts = var.target_hosts
  })

  provisioner "local-exec" {
    command = "chmod 644 ${self.filename}"
  }
}

# Generate extra vars file for Ansible with Ollama-specific variables
resource "local_file" "ansible_vars" {
  filename = "${path.module}/extra_vars.json"
  content  = jsonencode({
    ollama_version = "latest"
    ollama_models = ["llama2", "codellama"]
    nvidia_gpu_support = false
  })

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
      ansible all -i ${abspath(local_file.ansible_inventory.filename)} -m ping --timeout=30
      
      # Run the playbook
      ansible-playbook \
        -i ${abspath(local_file.ansible_inventory.filename)} \
        --extra-vars @${abspath(local_file.ansible_vars.filename)} \
        --timeout=${var.ansible_timeout} \
        -v \
        ${var.playbook_path}
    EOT
    
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_REMOTE_USER      = var.target_hosts[0].ansible_user
    }
  }

  triggers = {
    playbook_content   = filesha256(var.playbook_path)
    inventory_content  = local_file.ansible_inventory.content
    vars_content       = local_file.ansible_vars.content
    hosts_changed      = sha256(jsonencode(var.target_hosts))
  }
}