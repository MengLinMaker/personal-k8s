resource "hcloud_firewall" "base" {
  name   = "personal-k8s-node-1-firewall"
  labels = var.labels

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.allowed_ssh_cidrs
  }

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = var.allowed_ssh_cidrs
  }
}

resource "hcloud_server" "base" {
  name        = "personal-k8s-node-1"
  server_type = var.server_type
  image       = "ubuntu-24.04"
  location    = var.location
  ssh_keys    = var.ssh_key_ids
  labels      = var.labels

  firewall_ids = [hcloud_firewall.base.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
