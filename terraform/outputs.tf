output "kubeconfig" {
  description = "Kubeconfig for the Talos Kubernetes cluster."
  value       = module.talos.kubeconfig
  sensitive   = true
}

output "talosconfig" {
  description = "Talos config for the cluster."
  value       = module.talos.talosconfig
  sensitive   = true
}

output "hetzner_network_id" {
  description = "Hetzner private network ID created by the module."
  value       = module.talos.hetzner_network_id
}

output "public_ipv4_list" {
  description = "Public IPv4 addresses of all control plane nodes."
  value       = module.talos.public_ipv4_list
}

output "talos_image_id" {
  description = "Hetzner snapshot image ID used for x86 Talos nodes."
  value       = imager_image.talos_x86.image_id
}
