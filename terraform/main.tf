resource "hcloud_ssh_key" "default" {
  count      = var.ssh_public_key == null ? 0 : 1
  name       = "${var.server_name}-ssh"
  public_key = var.ssh_public_key
  labels     = var.labels
}

locals {
  ssh_keys = var.ssh_public_key == null ? var.ssh_key_ids : [hcloud_ssh_key.default[0].id]
}

resource "hcloud_firewall" "base" {
  name   = "${var.server_name}-firewall"
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
  name        = var.server_name
  server_type = var.server_type
  image       = var.image
  location    = var.location
  ssh_keys    = local.ssh_keys
  labels      = var.labels

  firewall_ids = [hcloud_firewall.base.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
