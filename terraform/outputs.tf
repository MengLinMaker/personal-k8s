output "server_id" {
  description = "Hetzner server ID."
  value       = hcloud_server.base.id
}

output "server_name" {
  description = "Hetzner server name."
  value       = hcloud_server.base.name
}

output "server_type" {
  description = "Hetzner server type."
  value       = hcloud_server.base.server_type
}

output "location" {
  description = "Hetzner server location."
  value       = hcloud_server.base.location
}

output "ipv4_address" {
  description = "Public IPv4 address."
  value       = hcloud_server.base.ipv4_address
}

output "ipv6_address" {
  description = "Public IPv6 address."
  value       = hcloud_server.base.ipv6_address
}
