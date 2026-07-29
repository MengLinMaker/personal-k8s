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
cp hetzner-dokploy/terraform/terraform.tfvars.example hetzner-dokploy/terraform/terraform.tfvars
cp hetzner-dokploy/.env.example hetzner-dokploy/.env
```

`terraform.tfvars` files are ignored by git because they contain secrets and local network details.

Generate or reuse an SSH key, then put the public key content in `ssh_public_key`:

```sh
task dokploy:gen:ssh
cat ~/.ssh/personal_dokploy_ed25519.pub
```

Apply `hetzner-dokploy/terraform` to create the server and install Dokploy.

Tailscale is bootstrapped automatically after Dokploy starts installing. The bootstrap script waits for `dokploy-network`, advertises that Docker subnet, and enables Tailscale SSH.

SSH is also enabled directly from `allowed_admin_cidrs` as a fallback:

```sh
task dokploy:ssh
```

For an existing server created without an SSH key, OpenTofu may need to replace the server before direct SSH works. To avoid replacement, add the same public key to `/root/.ssh/authorized_keys` once through the Hetzner web console or rescue mode.

## Commands

List root tasks:

```sh
task
```

Each stack also has its own Taskfile:

```sh
cd hetzner-dokploy && task
cd hetzner-k3s && task
```

## Experiments

There is also a separate single-node k3s experiment at `hetzner-k3s`. It is intentionally outside the Dokploy/OpenTofu path.

The k3s experiment also needs:

```sh
brew install vitobotta/tap/hetzner_k3s fluxcd/tap/flux kubectl
```

Flux is installed manually for the k3s experiment. App repo registrations are applied from `hetzner-k3s/platform/apps`.
