# Personal Infrastructure

Provisioning a small Dokploy VPS for personal projects.

## Dependencies

Install the local tools:

```sh
brew install go-task/tap/go-task opentofu
```

You also need a Hetzner Cloud API token with read/write access to the project.

## Configuration

Copy the example variables file and fill in the required values:

```sh
cp terraform/dokploy/terraform.tfvars.example terraform/dokploy/terraform.tfvars
```

`terraform.tfvars` files are ignored by git because they contain secrets and local network details.

Apply `terraform/dokploy` to create the server and install Dokploy.

SSH keys are optional. By default, `ssh_key_ids = []`, and the server is managed through the Dokploy UI first. If you add Hetzner SSH key IDs later, OpenTofu also opens SSH from `allowed_admin_cidrs`.

Tailscale bootstrap is optional. If `enable_tailscale = true` and `tailscale_auth_key` is set, cloud-init installs Tailscale and joins the server to your tailnet with Tailscale SSH enabled.

## Commands

List available tasks:

```sh
task
```
