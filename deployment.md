# Deployment

Deployment is intentionally simple:

1. OpenTofu provisions one Hetzner VPS.
2. Hetzner firewall rules expose SSH and Dokploy admin access only to admin CIDRs.
3. HTTP and HTTPS are public for deployed applications.
4. Cloud-init runs Dokploy's official installer.
5. If `tailscale_auth_key` is set, cloud-init installs Tailscale and joins the server to your tailnet with Tailscale SSH enabled.
6. Dokploy installs Docker, initializes Docker Swarm, and exposes the setup UI on port `3000`.

## OpenTofu Stacks

The primary OpenTofu stack is:

| Stack | Path | Purpose |
| --- | --- | --- |
| Dokploy | `terraform/dokploy` | Creates the Hetzner VPS, firewall, backups, and Dokploy bootstrap. |

The older Talos/Kubernetes stacks remain in the repository for reference, but they are no longer the recommended deployment path for this small personal environment.

## Why Dokploy

The single-node Kubernetes path was operationally noisy on a small VPS: the Kubernetes API and platform controllers consumed enough CPU and disk I/O to make bootstrap unreliable. Dokploy keeps the useful deployment UI and Docker workflow while avoiding the Kubernetes control-plane tax.

Dokploy's official installer expects ports `80`, `443`, and `3000` to be free. This stack opens `80` and `443` publicly for apps, while restricting `22` and `3000` to `allowed_admin_cidrs`.

The optional Tailscale bootstrap follows Dokploy's Tailscale guide, but only automates the initial server join and Tailscale SSH. Advertising the Dokploy Docker subnet is intentionally left out of first boot because `dokploy-network` only exists after Dokploy has initialized.
