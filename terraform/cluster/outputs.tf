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

output "debug_connection" {
  description = "Non-sensitive connection hints for debugging the single-node cluster."
  value = {
    node_ip        = module.talos.public_ipv4_list[0]
    talos_endpoint = module.talos.public_ipv4_list[0]
    talos_api_port = 50000
    kube_api_port  = 6443
    talos_health_command = join(" ", [
      "talosctl",
      "--talosconfig ./talosconfig",
      "--nodes ${module.talos.public_ipv4_list[0]}",
      "--endpoints ${module.talos.public_ipv4_list[0]}",
      "health",
    ])
    talos_dashboard_command = join(" ", [
      "talosctl",
      "--talosconfig ./talosconfig",
      "--nodes ${module.talos.public_ipv4_list[0]}",
      "--endpoints ${module.talos.public_ipv4_list[0]}",
      "dashboard",
    ])
    kubectl_nodes_command = "KUBECONFIG=./kubeconfig kubectl get nodes -o wide"
  }
}

output "talos_image_id" {
  description = "Hetzner snapshot image ID used for x86 Talos nodes."
  value       = var.talos_image_id_x86
}
