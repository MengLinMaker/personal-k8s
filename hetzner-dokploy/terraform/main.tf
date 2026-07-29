locals {
  server_name = "personal-dokploy-node-1"
  server_type = "cpx12"
  location    = "fsn1"
}

resource "hcloud_firewall" "dokploy" {
  name   = local.server_name
  labels = var.labels

  rule {
    description = "Allow all TCP from admin CIDRs"
    direction   = "in"
    protocol    = "tcp"
    port        = "1-65535"
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
    description = "Allow public app ports"
    direction   = "in"
    protocol    = "tcp"
    port        = "3001-3100"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
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
      - path: /usr/local/sbin/bootstrap-tailscale
        owner: root:root
        permissions: '0700'
        content: |
          #!/usr/bin/env bash
          set -euo pipefail
          exec > >(tee -a /var/log/bootstrap-tailscale.log) 2>&1

          echo "[$(date --iso-8601=seconds)] Starting Tailscale bootstrap"

          echo "Waiting for Docker..."
          for _ in $(seq 1 180); do
            if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
              break
            fi
            sleep 10
          done

          if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
            echo "Docker did not become ready" >&2
            exit 1
          fi

          echo "Waiting for dokploy-network..."
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

          echo "Installing Tailscale..."
          curl -fsSL https://tailscale.com/install.sh | sh
          echo "Enabling forwarding for subnet routes..."
          sysctl -w net.ipv4.ip_forward=1
          sysctl -w net.ipv6.conf.all.forwarding=1
          printf '%s\n' \
            'net.ipv4.ip_forward = 1' \
            'net.ipv6.conf.all.forwarding = 1' \
            >/etc/sysctl.d/99-tailscale.conf
          echo "Joining tailnet and advertising $dokploy_subnet..."
          tailscale up --ssh --advertise-routes="$dokploy_subnet" --auth-key=${jsonencode(var.tailscale_auth_key)}
          echo "[$(date --iso-8601=seconds)] Tailscale bootstrap complete"
      - path: /etc/systemd/system/bootstrap-tailscale.service
        owner: root:root
        permissions: '0644'
        content: |
          [Unit]
          Description=Bootstrap Tailscale for Dokploy
          After=network-online.target docker.service
          Wants=network-online.target

          [Service]
          Type=oneshot
          ExecStart=/usr/local/sbin/bootstrap-tailscale
          RemainAfterExit=yes

          [Install]
          WantedBy=multi-user.target
    runcmd:
      - curl -sSL https://dokploy.com/install.sh | sh &
      - systemctl daemon-reload
      - systemctl enable --now bootstrap-tailscale.service
  EOT
}
