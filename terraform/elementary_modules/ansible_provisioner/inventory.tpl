[%{ if group != null && length(group) > 0 }${group}%{ else }all%{ endif }]
%{ for host in hosts ~}
${host.name} ansible_host=${host.ansible_host} ansible_user=${host.ansible_user} ansible_ssh_private_key_file=${host.ansible_ssh_private_key_file}
%{ endfor ~}