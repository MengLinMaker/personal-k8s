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

resource "hcloud_ssh_key" "dokploy_admin" {
  name       = "${local.server_name}-admin"
  public_key = trimspace(var.ssh_public_key)
  labels     = var.labels
}

resource "hcloud_server" "dokploy" {
  name        = local.server_name
  image       = "ubuntu-24.04"
  server_type = local.server_type
  location    = local.location
  backups     = true
  labels      = var.labels
  firewall_ids = [
    hcloud_firewall.dokploy.id,
  ]
  ssh_keys = [
    hcloud_ssh_key.dokploy_admin.id,
  ]

  user_data = <<-EOT
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - ca-certificates
      - curl
      - gnupg
    write_files:
      - path: /usr/local/sbin/bootstrap-dokploy
        owner: root:root
        permissions: '0700'
        content: |
          #!/usr/bin/env bash
          set -euo pipefail

          dokploy_subnet=""
          for _ in $(seq 1 180); do
            dokploy_subnet="$(docker network inspect --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}' dokploy-network 2>/dev/null || true)"
            if [ -n "$dokploy_subnet" ]; then
              break
            fi
            sleep 10
          done

          if [ -z "$dokploy_subnet" ]; then
            echo "dokploy-network subnet was not found" >&2
            exit 1
          fi

          curl -fsSL https://tailscale.com/install.sh | sh
          tailscale up --ssh --advertise-routes="$dokploy_subnet" --auth-key=${jsonencode(var.tailscale_auth_key)}
    runcmd:
      - /usr/local/sbin/bootstrap-dokploy &
      - curl -sSL https://dokploy.com/install.sh | sh
  EOT
}
