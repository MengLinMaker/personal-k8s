locals {
  server_name = "personal-dokploy-node-1"
  server_type = "cpx12"
  location    = "fsn1"

  tailscale_cloud_init = var.enable_tailscale ? [
    {
      path        = "/root/.tailscale-auth-key"
      owner       = "root:root"
      permissions = "0600"
      content     = var.tailscale_auth_key
    }
  ] : []

  tailscale_runcmd = var.enable_tailscale ? [
    "curl -fsSL https://tailscale.com/install.sh | sh",
    "tailscale up --auth-key=file:/root/.tailscale-auth-key --ssh --hostname=${local.server_name}",
  ] : []
}

resource "terraform_data" "tailscale_auth_key_required" {
  count = var.enable_tailscale && var.tailscale_auth_key == null ? 1 : 0

  input = "Set tailscale_auth_key when enable_tailscale is true."

  lifecycle {
    precondition {
      condition     = false
      error_message = "Set tailscale_auth_key when enable_tailscale is true."
    }
  }
}

resource "hcloud_firewall" "dokploy" {
  name   = local.server_name
  labels = var.labels

  dynamic "rule" {
    for_each = length(var.ssh_key_ids) > 0 ? [1] : []

    content {
      description = "Allow SSH from admin CIDRs"
      direction   = "in"
      protocol    = "tcp"
      port        = "22"
      source_ips  = var.allowed_admin_cidrs
    }
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
  ssh_keys    = length(var.ssh_key_ids) > 0 ? var.ssh_key_ids : null
  backups     = true
  labels      = var.labels
  firewall_ids = [
    hcloud_firewall.dokploy.id,
  ]

  user_data = yamlencode({
    package_update  = true
    package_upgrade = true
    packages = [
      "ca-certificates",
      "curl",
      "gnupg",
    ]
    write_files = local.tailscale_cloud_init
    runcmd = concat(
      [
        "curl -sSL https://dokploy.com/install.sh | sh",
      ],
      local.tailscale_runcmd,
    )
  })
}
