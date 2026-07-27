output "server_name" {
  description = "Dokploy server name."
  value       = hcloud_server.dokploy.name
}

output "server_type" {
  description = "Hetzner server type."
  value       = local.server_type
}

output "location" {
  description = "Hetzner location."
  value       = local.location
}

output "public_ipv4" {
  description = "Public IPv4 address of the Dokploy server."
  value       = hcloud_server.dokploy.ipv4_address
}

output "dokploy_url" {
  description = "Initial Dokploy panel URL. Access is restricted by the Hetzner firewall to allowed_admin_cidrs."
  value       = "http://${hcloud_server.dokploy.ipv4_address}:3000"
}

output "ssh_command" {
  description = "SSH command for the Dokploy server."
  value       = "ssh root@${hcloud_server.dokploy.ipv4_address}"
}
