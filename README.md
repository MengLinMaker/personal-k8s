# Personal Kubernetes

Provisioning a Kubernetes cluster for personal projects.

## Dependencies

Install the local tools:

```sh
brew install go-task/tap/go-task opentofu helm kubectl talosctl
```

You also need a Hetzner Cloud API token with read/write access to the project.

## Configuration

Copy the example variables files and fill in the required values:

```sh
cp terraform/image/terraform.tfvars.example terraform/image/terraform.tfvars
cp terraform/cluster/terraform.tfvars.example terraform/cluster/terraform.tfvars
```

`terraform.tfvars` files are ignored by git because they contain secrets and local network details.

Apply `terraform/image` first, then copy its `talos_image_id_x86` output into `terraform/cluster/terraform.tfvars`.

## Commands

List available tasks:

```sh
task
```
