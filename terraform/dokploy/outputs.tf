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

output "tailscale_dokploy_url" {
  description = "Dokploy URL over Tailscale MagicDNS when tailscale_auth_key is set and MagicDNS is enabled."
  value       = var.enable_tailscale ? "http://${local.server_name}:3000" : null
}

output "ssh_command" {
  description = "SSH command for the Dokploy server, when ssh_key_ids is not empty."
  value       = length(var.ssh_key_ids) > 0 ? "ssh root@${hcloud_server.dokploy.ipv4_address}" : null
}

output "tailscale_ssh_command" {
  description = "Tailscale SSH command when tailscale_auth_key is set and Tailscale SSH is enabled in the tailnet."
  value       = var.enable_tailscale ? "ssh root@${local.server_name}" : null
}
