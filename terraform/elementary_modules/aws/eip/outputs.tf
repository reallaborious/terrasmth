output "eip_id" {
  value = aws_eip.this.id
}

output "public_ip" {
  value = aws_eip.this.public_ip
}

output "public_ip_id" {
  value       = aws_eip.this.id
  description = "Unified public IP id alias"
}
