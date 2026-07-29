# Hetzner Dokploy

Provisioning a small Dokploy VPS for personal projects.

## Install tools

```sh
brew install go-task/tap/go-task opentofu
```

You also need a Hetzner Cloud API token with read/write access to the project.

## Configure

Copy the example files and fill in the required values:

```sh
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
cp .env.example .env
```

`terraform.tfvars` files are ignored by git because they contain secrets and local network details.

Generate or reuse an SSH key, then put the public key content in `ssh_public_key`:

```sh
task gen:ssh
cat ~/.ssh/personal_dokploy_ed25519.pub
```

## Deploy

Apply `terraform` to create the server and install Dokploy.

Deployment flow:

1. OpenTofu provisions one Hetzner VPS.
2. Hetzner firewall rules expose Dokploy admin access only to admin CIDRs.
3. HTTP and HTTPS are public for deployed applications.
4. Cloud-init starts Dokploy's official installer in the background because the installer is long-running.
5. Cloud-init starts the Tailscale bootstrap service.
6. Dokploy installs Docker, initializes Docker Swarm, and exposes the setup UI on port `3000`.
7. The Tailscale bootstrap waits for Docker and `dokploy-network`, advertises that Docker subnet, and enables Tailscale SSH.

Dokploy's official installer expects ports `80`, `443`, and `3000` to be free. This stack opens `80` and `443` publicly for apps, while restricting `22` and `3000` to `allowed_admin_cidrs`.

## SSH

SSH is enabled directly from `allowed_admin_cidrs` as a fallback:

```sh
task ssh
```

For an existing server created without an SSH key, OpenTofu may need to replace the server before direct SSH works. To avoid replacement, add the same public key to `/root/.ssh/authorized_keys` once through the Hetzner web console or rescue mode.
