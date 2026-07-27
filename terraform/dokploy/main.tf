locals {
  server_name = "personal-dokploy-node-1"
  server_type = "cpx12"
  location    = "fsn1"
}

resource "hcloud_firewall" "dokploy" {
  name   = local.server_name
  labels = var.labels

  rule {
    description = "Allow SSH from admin CIDRs"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = var.allowed_admin_cidrs
  }

  rule {
    description = "Allow HTTP"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "Allow HTTPS"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "Allow Dokploy panel from admin CIDRs"
    direction   = "in"
    protocol    = "tcp"
    port        = "3000"
    source_ips  = var.allowed_admin_cidrs
  }
}

resource "hcloud_server" "dokploy" {
  name        = local.server_name
  image       = "ubuntu-24.04"
  server_type = local.server_type
  location    = local.location
  ssh_keys    = var.ssh_key_ids
  backups     = true
  labels      = var.labels
  firewall_ids = [
    hcloud_firewall.dokploy.id,
  ]

  user_data = <<-EOT
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - ca-certificates
      - curl
      - gnupg
    runcmd:
      - curl -sSL https://dokploy.com/install.sh | sh
  EOT
}
