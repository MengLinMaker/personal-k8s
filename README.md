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

Tailscale is bootstrapped automatically after Dokploy starts installing. The bootstrap script waits for `dokploy-network`, advertises that Docker subnet, and enables Tailscale SSH.

## Commands

List available tasks:

```sh
task
```
